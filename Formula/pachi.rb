class Pachi < Formula
  desc "Software for the Board Game of Go/Weiqi/Baduk"
  homepage "https://pachi.or.cz/"
  url "https://github.com/pasky/pachi/archive/pachi-12.50.tar.gz"
  sha256 "62c8d44bd4610fe9534a1f21bb092da209c9fb8dcb8d39558d79adabe31e740a"
  head "https://github.com/pasky/pachi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8481a1aaa57deb0b0899eaa4f9457d46407e289e8bf5e9206dc94921eb24215b" => :catalina
    sha256 "3112537672262b5497287087fd355e368a695148b409a8aa8b98f92f061f4d56" => :mojave
    sha256 "8fd665e94fcaab1a1c0bacce23eade2182be7a3bd3010bd53af5a1e2b8bb57b4" => :high_sierra
  end

  fails_with :clang if MacOS.version == :mavericks

  resource "patterns" do
    url "https://sainet-dist.s3.amazonaws.com/pachi_patterns.zip"
    sha256 "73045eed2a15c5cb54bcdb7e60b106729009fa0a809d388dfd80f26c07ca7cbc"
  end

  resource "book" do
    url "https://gnugo.baduk.org/books/ra6.zip"
    sha256 "1e7ffc75c424e94338308c048aacc479da6ac5cbe77c0df8adc733956872485a"
  end

  def install
    ENV["MAC"] = "1"
    ENV["DOUBLE_FLOATING"] = "1"

    # Work around Xcode 11 clang bug
    if DevelopmentTools.clang_build_version >= 1010
      inreplace "Makefile", "CFLAGS       :=", "CFLAGS := -fno-stack-check"
    end

    # https://github.com/pasky/pachi/issues/78
    inreplace "Makefile", "build.h: .git/HEAD .git/index", "build.h:"
    inreplace "Makefile", "DCNN=1", "DCNN=0"

    system "make"
    bin.install "pachi"

    pkgshare.install resource("patterns")
    pkgshare.install resource("book")
  end

  def caveats
    <<~EOS
      This formula also downloads additional data, such as opening books
      and pattern files. They are stored in #{opt_pkgshare}.

      At present, pachi cannot be pointed to external files, so make sure
      to set the working directory to #{opt_pkgshare} if you want pachi
      to take advantage of these additional files.
    EOS
  end

  test do
    assert_match /^= [A-T][0-9]+$/, pipe_output("#{bin}/pachi", "genmove b\n", 0)
  end
end
