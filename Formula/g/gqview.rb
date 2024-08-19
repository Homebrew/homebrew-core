class Gqview < Formula
  desc "Image browser"
  homepage "https://gqview.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gqview/gqview/2.0.4/gqview-2.0.4.tar.gz"
  sha256 "97e3b7ce5f17a315c56d6eefd7b3a60b40cc3d18858ca194c7e7262acce383cb"
  revision 3

  bottle do
    sha256 arm64_sonoma:   "1211ff5095c73359c2652426a098a1139e1f225d19abe32a286dda7796c60c96"
    sha256 arm64_ventura:  "a16fd3dcd391be5e7568bb232037c4af9c677cca3f520ab0886ea679cf5002f1"
    sha256 arm64_monterey: "ffe4e090d128841b174008928e53dcd153827c075ed8c8124cf6164f5733a9df"
    sha256 arm64_big_sur:  "9b80b415172fc45373bcb1c68b03b3c0c26e6181e3c5ff4e353c7b685fbf6524"
    sha256 sonoma:         "7c3aeb0a73262b9b116a351e7879aff21ea819d7c4c5821124bee4143b19bf04"
    sha256 ventura:        "bd1802a32656bd2d9b61a0f7c9132130e2e3fea29aaefd4cb14616d33083ffbe"
    sha256 monterey:       "32146672314f1d61669e46d8d01d6ac205d15d75d62a6bed5af1281335541ee7"
    sha256 big_sur:        "34819384f6dd734a0000543eed0865a48ad9b218d9bbd0662b64cf2edc4cd3c4"
    sha256 catalina:       "e8e56389d265444d10d7859b63736370c2b88b98d4f8b4254bdecf2f3b7c8ab4"
    sha256 mojave:         "dc9cc0efc66c0e2156efeba84201c54711288e96868367bde264dbfaff14236f"
    sha256 high_sierra:    "faeb25a25899fc5d18b2097574c3975648aaab4b8a55545e5ba6579335c2f587"
    sha256 sierra:         "b0e983e36c58634a2ae893003567dac0737c012811c1dcb64f0def22fc11f604"
    sha256 x86_64_linux:   "18698348461bc51c97a1439a409726c32000f608f5f71f4ef7503c099899e99f"
  end

  # GTK 2 is EOL: https://blog.gtk.org/2020/12/16/gtk-4-0/
  # Last release on 2006-12-02
  disable! date: "2024-01-21", because: :unmaintained

  depends_on "pkg-config" => :build
  depends_on "gtk+"

  def install
    ENV.append "LIBS", "-lm"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system bin/"gqview", "--version"
  end
end
