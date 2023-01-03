class Hamlib < Formula
  desc "Ham radio control libraries"
  homepage "http://www.hamlib.org/"
  url "https://github.com/Hamlib/Hamlib/releases/download/4.5.3/hamlib-4.5.3.tar.gz"
  sha256 "e1818e9df0e59023d2dff320c41c5c622b02a0afd3e50c3155694e1a9014f260"
  license "LGPL-2.1-or-later"
  head "https://github.com/hamlib/hamlib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ce49e9a017fe64c39ed86f61db0234f2bc89345146a41dc9b14245cfda5af0e8"
    sha256 cellar: :any,                 arm64_monterey: "3fae4a80d1f5d033c62c97109bc567e4f661cce902af5874be8ad68941e67887"
    sha256 cellar: :any,                 arm64_big_sur:  "19f042a1dc22e66638ac1d084f99825dc224b2b3eb9a92cf394b073b617e24ca"
    sha256 cellar: :any,                 ventura:        "f32308be5a47856a168f443660163cbecfdf1f18693f440ec2620b206c41d084"
    sha256 cellar: :any,                 monterey:       "792c4b803ea71ffaa98c56696ece8f0047f7f0647075d6b91a1f4f0bdcb80a5a"
    sha256 cellar: :any,                 big_sur:        "257e3dc1591f84eec57f3f9bbd07f1b66bfe2e2cbecf1563bdaf244a6ac04f61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea19a46040dd9ffcd51cfb75ed273cd1f0117c2cb9d4f6ffcc0507f72f59d069"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool"
  depends_on "libusb-compat"

  fails_with gcc: "5"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/rigctl", "-V"
  end
end
