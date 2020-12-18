class Pachi < Formula
  desc "Software for the Board Game of Go/Weiqi/Baduk"
  homepage "https://pachi.or.cz/"
  url "https://github.com/pasky/pachi/archive/pachi-12.60.tar.gz"
  sha256 "3c05cf4fe5206ba4cbe0e0026ec3225232261b44e9e05e45f76193b4b31ff8e9"
  license "GPL-2.0"
  head "https://github.com/pasky/pachi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b1ae6a01f632409937bb18ac34b7e75e6142c101a629d951d17c0d8f756d37c" => :big_sur
    sha256 "e1cac19564a176a50d27f08b4e395a53ff4144dc17fd93dcaa013adfc8cca83a" => :catalina
    sha256 "76edc1b521dfb93e8c6573b689c8bc5a01103888f2f7310fd46aa53d8b6ea0dc" => :mojave
    sha256 "476509041b907edfd0380bc91a3fd4fc41b359bae58524ab4ab8017df4f61fe0" => :high_sierra
  end

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
