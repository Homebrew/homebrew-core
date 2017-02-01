class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v0.13.0/fwup-0.13.0.tar.gz"
  sha256 "a2b175ae1e0e6235165f1f608fc9cb2b1a1b06bf99cb4dc4d7c5baa7a9007086"

  bottle do
    cellar :any
    sha256 "e4690576e77ce432ddc51171c62fecbd2552a24e833eb650136d7cb056fce9e1" => :sierra
    sha256 "40c3d1c414c7f649259a71c5255b7b85879cfccae85629025482c1cb64ba72ea" => :el_capitan
    sha256 "92341d1e3633ebef6a4d177eb92a7af2f845e71c912959ab0076395593125f4e" => :yosemite
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
