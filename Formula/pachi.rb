class Pachi < Formula
  desc "Software for the Board Game of Go/Weiqi/Baduk"
  homepage "https://pachi.or.cz/"
  url "https://github.com/pasky/pachi/archive/pachi-12.70.tar.gz"
  sha256 "5c5f081fec5ff6ad984f75c32c4c5b3d7d5b9dc5677a8058d9146b35fa922733"
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

  depends_on "caffe"

  resource "datafiles" do
    url "https://launchpad.net/~lemonsqueeze/+archive/ubuntu/pachi/+sourcefiles/pachi-go-data/12.70/pachi-go-data_12.70.orig.tar.xz"
    sha256 "f907292e34d3d4e79b0ca1d6181b36fe15aad3741a02f622094657a909910a8b"
  end

  def install
    ENV["DESTDIR"] = HOMEBREW_PREFIX
    ENV["DATADIR"] = pkgshare
    ENV["GENERIC"] = "1"                # make cpu-generic binary (intel)
    ENV["MAC"] = "1"
    ENV["DOUBLE_FLOATING"] = "1"

    # https://github.com/pasky/pachi/issues/78
    inreplace "Makefile", "build.h: .git/HEAD .git/index", "build.h:"

    system "make"

    buildpath.install resource("datafiles")     # copy missing datafiles (dcnn)
    system "make", "install"
    system "make", "install-data"               # install datafiles in /usr/share/pachi
  end

  test do
    assert_match(/^= [A-T][0-9]+$/, pipe_output("#{bin}/pachi", "genmove b\n", 0))
  end
end
