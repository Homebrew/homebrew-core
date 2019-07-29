class Adplug < Formula
  desc "Free, hardware independent AdLib sound player library"
  homepage "https://adplug.github.io"
  url "https://github.com/adplug/adplug/releases/download/adplug-2.3.1/adplug-2.3.1.tar.bz2"
  sha256 "5ba628cfa24a37b89ac6f70c6ec8fa8157405428f508828fdf5d372ff99483d9"

  bottle do
    cellar :any
    sha256 "bf68be72cffe219d9450afa96b4445c1db273c7ce4ea664d023341cc2d9b6fb7" => :mojave
    sha256 "8b5a35c8e06097a6d12d172e1c2682542e4dd3eb6264933b8c0fa29b99d80e9e" => :high_sierra
    sha256 "66f5ef8ac8ff8a1e6909098259cc501057eab601e416df3f23ca5cf975b09ac6" => :sierra
    sha256 "a5af729b9f94e3b3665ce445880fd55186668c84dbd6e8e05ba945f40c514a99" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libbinio"

  resource "ksms" do
    url "http://advsys.net/ken/ksmsongs.zip"
    sha256 "2af9bfc390f545bc7f51b834e46eb0b989833b11058e812200d485a5591c5877"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    resource("ksms").stage do
      mkdir "#{testpath}/.adplug"
      system "#{bin}/adplugdb", "-v", "add", "JAZZSONG.KSM"
    end
  end
end
