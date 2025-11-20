class Pachi < Formula
  desc "Software for the Board Game of Go/Weiqi/Baduk"
  homepage "https://pachi.or.cz/"
  url "https://github.com/pasky/pachi/archive/refs/tags/pachi-12.84.tar.gz"
  sha256 "5ced9ffd9fdb0ee4cdb24ad341abbcb7df0ab8a7f244932b7dd3bfa0ff6180ba"
  license "GPL-2.0-only"
  head "https://github.com/pasky/pachi.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "3fc9dffa9c09610c0e425d534cfbffbf06ab07ad152c54772d36f7961ce6be33"
    sha256 arm64_sequoia:  "fd4a7a487d1c0d4c7597970a99008f0def56e08ae402d1d63832b0b5d41f2823"
    sha256 arm64_sonoma:   "57b6e6f43f52e5ef856feccee3a1a828872a90fb45a9e72149147ef8aa1e129d"
    sha256 arm64_ventura:  "59b6a51156dc47e96991c92ce1fdd8060a4b9f2789f53ac515d9b08b8f117941"
    sha256 arm64_monterey: "cba618e09fd5920a22b9e96b44aff7daaf2c1de834cc9b30dc1d13e9b3ce9498"
    sha256 sonoma:         "08420848a56934b074a7044ceb0acc38c49c169a0d784b4b5bdf0af3431ba73c"
    sha256 ventura:        "4f2ff8e1819b0982ae09db3be0935c36e38c809795d4b45776076e9a15e0c1d2"
    sha256 monterey:       "8d0c1b96f212172117f2f44d2880d906d043c0601d8a7b1dd4dc796cf8ddc57d"
    sha256 arm64_linux:    "4b29e4d8ee8bf2f28f3aefbcd40f7c3042c14cb9398df6781006ada3e2e7ed51"
    sha256 x86_64_linux:   "eb13f42af4891d563b870f8840182c9b6f99f76dfd7afcfeaf9c1cbf8bff4790"
  end

  resource "datafiles" do
    url "https://github.com/pasky/pachi/releases/download/pachi-12.84/pachi-12.84-linux-static.zip", using: :nounzip
    sha256 "c9b080a93468cb4eacfb6cb43ccd3c6ca2caacc784b02ebe5ec7ba3e4e071922"
  end

  def install
    ENV["MAC"] = "1" if OS.mac?
    ENV["GENERIC"] = "1"
    ENV["DOUBLE_FLOATING"] = "1"

    # https://github.com/pasky/pachi/issues/78
    inreplace "Makefile" do |s|
      if build.stable?
        s.gsub! "build.h: build.h.git", "build.h:"
        s.gsub! "@cp build.h.git", "echo '#define PACHI_GIT_BRANCH \"\"\\n#define PACHI_GIT_HASH \"\"' >>"
      end
      s.change_make_var! "DCNN", "0"
      s.change_make_var! "PREFIX", prefix
    end

    # Manually extract data files from Linux build, which is actually a zip file
    system "unzip", "-oj", resource("datafiles").cached_download, "*/*", "-x", "*/*/*", "-d", buildpath
    system "make"
    system "make", "install"
  end

  test do
    assert_match(/^= [A-T][0-9]+$/, pipe_output(bin/"pachi", "genmove b\n", 0))
  end
end
