class Adplug < Formula
  desc "Free, hardware independent AdLib sound player library"
  homepage "https://adplug.github.io"
  url "https://github.com/adplug/adplug/releases/download/adplug-2.3.3/adplug-2.3.3.tar.bz2"
  sha256 "a0f3c1b18fb49dea7ac3e8f820e091a663afa5410d3443612bf416cff29fa928"
  license "LGPL-2.1"

  bottle do
    cellar :any
    sha256 "1698e0290de585761d85501881c22826662a4e1a04d5818a1a45d00a98f306ef" => :catalina
    sha256 "9dc95d2cd84290b55285581c4214234afe13c009be2a67f3ceeb5de39ffe0729" => :mojave
    sha256 "d9be8ef57f38e700c36e0f00563f5d31256112e1d2a870a97c3ac4d75ae138f2" => :high_sierra
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
