class Gqview < Formula
  desc "Image browser"
  homepage "https://gqview.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gqview/gqview/2.0.4/gqview-2.0.4.tar.gz"
  sha256 "97e3b7ce5f17a315c56d6eefd7b3a60b40cc3d18858ca194c7e7262acce383cb"
  revision 3

  # The "gqview" directory is where stable versions are found, so we use it in
  # the regex to avoid matching releases in the "unstable" directory.
  livecheck do
    url :stable
    regex(%r{url=.*?/gqview/[^/]+/gqview[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "ffe4e090d128841b174008928e53dcd153827c075ed8c8124cf6164f5733a9df"
    sha256 arm64_big_sur:  "9b80b415172fc45373bcb1c68b03b3c0c26e6181e3c5ff4e353c7b685fbf6524"
    sha256 monterey:       "32146672314f1d61669e46d8d01d6ac205d15d75d62a6bed5af1281335541ee7"
    sha256 big_sur:        "34819384f6dd734a0000543eed0865a48ad9b218d9bbd0662b64cf2edc4cd3c4"
    sha256 catalina:       "e8e56389d265444d10d7859b63736370c2b88b98d4f8b4254bdecf2f3b7c8ab4"
    sha256 mojave:         "dc9cc0efc66c0e2156efeba84201c54711288e96868367bde264dbfaff14236f"
    sha256 high_sierra:    "faeb25a25899fc5d18b2097574c3975648aaab4b8a55545e5ba6579335c2f587"
    sha256 sierra:         "b0e983e36c58634a2ae893003567dac0737c012811c1dcb64f0def22fc11f604"
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/gqview", "--version"
  end
end
