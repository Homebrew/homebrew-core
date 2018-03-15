class Adplug < Formula
  desc "Free, hardware independent AdLib sound player library"
  homepage "https://adplug.github.io"
  url "https://github.com/adplug/adplug/releases/download/adplug-2.3/adplug-2.3.tar.bz2"
  sha256 "f64a37f6243836bd0c9c1b7c3a563e47f4b15676d30c074e88b75b2415bfdf6a"

  bottle do
    sha256 "801ee9cf6f6e9a0c26042a155a8740ebc9a2e8e8bc027c3cba6e05a02a9a4f0f" => :high_sierra
    sha256 "560fd72ee1b2f6f8a1287dc4944cc00df9d8fda29a947da124aa1ce6e53f138b" => :sierra
    sha256 "643caa5ad48d38e26fd6adce9831a220680a0697bdbde5ca8d69de5403555589" => :el_capitan
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
