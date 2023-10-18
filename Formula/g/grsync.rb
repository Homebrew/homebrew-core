class Grsync < Formula
  desc "GUI for rsync"
  homepage "https://www.opbyte.it/grsync/"
  url "https://downloads.sourceforge.net/project/grsync/grsync-1.3.1.tar.gz"
  sha256 "33cc0e25daa62e5ba7091caea3c83a8dc74dc5d7721c4501d349f210c4b3c6d3"
  license "GPL-2.0"

  bottle do
    sha256 arm64_sonoma:   "fd5a3b8ad7b5de7ee1bd25767a34c2a432a4332176665b780a9723abfb0fb418"
    sha256 arm64_ventura:  "39d381a9ac5afe877312853cd7ec9a2cb6c5460adedd76d12011e6a88d1eb59a"
    sha256 arm64_monterey: "32671b0162b77e802079651b54d04dfa60fba61615e4392c93e905c219c5d705"
    sha256 arm64_big_sur:  "62d904f3e87bc6e4d5af9714f07ca04a726656fd137dddec7690c334a084e78f"
    sha256 sonoma:         "04be26487941d4e9911e1667fcb50815357b6291d76ada393747471ff6149833"
    sha256 ventura:        "90a7e58480143733b0a103edf01a995774d2cf380c317988967c575357b6f241"
    sha256 monterey:       "34f6b19b970ece35695bd8642aa5fb8834476596de6915ac2174a849e1038dd5"
    sha256 big_sur:        "7974e843681ed6e904617ff9f33c15109a001b7eda1afebfa4b5976b29ae5254"
    sha256 x86_64_linux:   "3802fa7c04a31a45f1be977efd420e45feb0ddcf91c4c1c423b7223b9e3eb5bb"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gtk+3"

  uses_from_macos "perl" => :build

  def install
    ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5" unless OS.mac?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-unity",
                          "--prefix=#{prefix}"
    chmod "+x", "install-sh"
    system "make", "install"
  end

  test do
    # running the executable always produces the GUI, which is undesirable for the test
    # so we'll just check if the executable exists
    assert_predicate bin/"grsync", :exist?
  end
end
