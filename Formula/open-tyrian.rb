class OpenTyrian < Formula
  desc "Open-source port of Tyrian"
  homepage "https://bitbucket.org/opentyrian/opentyrian"
  url "http://www.camanis.net/opentyrian/releases/opentyrian-2.1.20130907-src.tar.gz"
  sha256 "f54b6b3cedcefa187c9f605d6164aae29ec46a731a6df30d351af4c008dee45f"
  head "https://bitbucket.org/opentyrian/opentyrian", :using => :hg

  bottle do
    sha256 "f9761c338f5e39984b19661cb95293eae561fb24762ccf5721f91105e353dd20" => :el_capitan
    sha256 "370c59cf4f742979b78c7923c57b533f6c5ec8eec3522db7d9143dd07554334d" => :yosemite
    sha256 "730f02623ca48c3bb9f40f7610b01988a3434d7cb6bf5ecda013300206fdd21d" => :mavericks
  end

  depends_on "sdl"
  depends_on "sdl_net"

  resource "data" do
    url "http://camanis.net/tyrian/tyrian21.zip"
    sha256 "7790d09a2a3addcd33c66ef063d5900eb81cc9c342f4807eb8356364dd1d9277"
  end

  def install
    datadir = pkgshare/"data"
    datadir.install resource("data")
    args = []
    if build.head?
      args << "TYRIAN_DIR=#{datadir}"
    else
      inreplace "src/file.c", "/usr/share/opentyrian/data", datadir
    end
    system "make", *args
    bin.install "opentyrian"
  end

  def caveats
    "Save games will be put in ~/.opentyrian"
  end

  test do
    system "#{bin}/opentyrian", "--help"
  end
end
