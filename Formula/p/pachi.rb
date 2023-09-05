class Pachi < Formula
  desc "Software for the Board Game of Go/Weiqi/Baduk"
  homepage "https://pachi.or.cz/"
  url "https://github.com/pasky/pachi/archive/pachi-12.60.tar.gz"
  sha256 "3c05cf4fe5206ba4cbe0e0026ec3225232261b44e9e05e45f76193b4b31ff8e9"
  license "GPL-2.0"
  head "https://github.com/pasky/pachi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d25307a303833c144652b596baac8346e8274ed1669c5710f77675d978670692"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c38b47dfb6e9f48507f47be141963ea5fb4b6329a83f015f4bd0d52c09325408"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71f7bf11f6d68a8768468e4494cdc0785f484a5ccd7713cfc4327f049e79e80a"
    sha256 cellar: :any_skip_relocation, ventura:        "10306782a64e73d770c861e44c616a13cd417df1c346195f42426f62db6c1ec6"
    sha256 cellar: :any_skip_relocation, monterey:       "7079a129c324c7411aabe2c5357f3b5c86658bcec6b897f06e8cccf02e775a23"
    sha256 cellar: :any_skip_relocation, big_sur:        "d14dec70d5fedd0d7ba63b05f175b06b12c40e1da71d24da64712ce63858dae1"
    sha256 cellar: :any_skip_relocation, catalina:       "9a2adc64bf7dbfbaf9e3d9ff940d6c5bcb0e4040160ed62f57751ec87281132e"
    sha256 cellar: :any_skip_relocation, mojave:         "c88f24dd1e7a267848eab540dc2b0961962825ab6e7088fc24b335159dacf31c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0fc26989c0cf90b6fa2256e129b0b87993464ec27ad88fefe569abdd9702292"
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
    assert_match(/^= [A-T][0-9]+$/, pipe_output("#{bin}/pachi", "genmove b\n", 0))
  end
end
