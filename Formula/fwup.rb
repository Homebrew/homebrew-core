class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v0.12.0/fwup-0.12.0.tar.gz"
  sha256 "cefa3c213f54583ade0f1ed996795f5efdbb97fb10ca1b40fd9d84cc98281ece"

  bottle do
    cellar :any
    sha256 "837c36e723f47d1f43df4b7d19a21a61d0a41cd04154977da4586bd7fa359cbe" => :sierra
    sha256 "40d4b318e33ae5183f6cc6db94b0577edc2b63baaad226e1db4e7290bc3a40e5" => :el_capitan
    sha256 "dfc0c5b6f92a39643edc23270fa68a85a37cfa34b4327bbde6084344ba6e5abb" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "confuse"
  depends_on "libarchive"
  depends_on "libsodium"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system bin/"fwup", "-g"
    assert File.exist?("fwup-key.priv"), "Failed to create fwup-key.priv!"
    assert File.exist?("fwup-key.pub"), "Failed to create fwup-key.pub!"
  end
end
