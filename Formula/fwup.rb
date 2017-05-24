class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v0.14.3/fwup-0.14.3.tar.gz"
  sha256 "657e2732d9aff172c529cc0e6fe6afe68950d25080e190cb00b7756654508beb"
  revision 1

  bottle do
    cellar :any
    sha256 "43ed22c9ca356ed359ddf084ae95316c106a2081a298cf159d39c33e0db61f26" => :sierra
    sha256 "29f2f36f16c9c7166746d4e7abff9bc4fa32dc6a34b32a0786132c06eb934cd2" => :el_capitan
    sha256 "d16b0ef664bd2f837050eceeaec884484684e2b9647d488f09f9ba8f1a5312d7" => :yosemite
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
