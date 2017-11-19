class Adplug < Formula
  desc "Free, hardware independent AdLib sound player library"
  homepage "https://adplug.github.io"
  url "https://github.com/adplug/adplug/releases/download/adplug-2.3/adplug-2.3.tar.bz2"
  sha256 "f64a37f6243836bd0c9c1b7c3a563e47f4b15676d30c074e88b75b2415bfdf6a"

  bottle do
    rebuild 1
    sha256 "023ab05e5b78a8caaf2e930632d4508bce44ba358131237be59fd3e61d404e2a" => :high_sierra
    sha256 "4eed30fe5dd35145d3a6a7c4e90aa6e0e5fd82702f8f7e4e01d15133a676b643" => :sierra
    sha256 "93e13fe26543c02933533eb1c2f36e500133f3cb685f8b63cd6d3cc452ce1357" => :el_capitan
    sha256 "565bd6f10cc1be2142e13b0da0fefbbfa338736a36f4f317ba3b3bc440fb2132" => :yosemite
    sha256 "ffc73557be38d8cb2c886f6b7fa000aeb3b0b9d08afb1f3173fbf74fd005c0b9" => :mavericks
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
