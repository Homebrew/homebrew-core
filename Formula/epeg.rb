class Epeg < Formula
  desc "JPEG/JPG thumbnail scaling"
  homepage "https://github.com/mattes/epeg"
  url "https://github.com/mattes/epeg/archive/v0.9.2.tar.gz"
  sha256 "f8285b94dd87fdc67aca119da9fc7322ed6902961086142f345a39eb6e0c4e29"
  license "MIT-enna"
  revision 1
  head "https://github.com/mattes/epeg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "888f27426296b7ee7630be6dc8e1e45c5c8ef1412e64cb3558244269c53a97f7"
    sha256 cellar: :any,                 arm64_big_sur:  "23d5cd2ef6cfda33341c0109ef84ec9aee615287b0a3826d9e4ad23d8637de3e"
    sha256 cellar: :any,                 monterey:       "4cd97358d56e238254eeb3e555b2ed29d478c6efa947c91fef735e436642f881"
    sha256 cellar: :any,                 big_sur:        "970d5c3edcbe3ab1896a2e61566ceea303d2d565cc7e2267f5dc474ab9299496"
    sha256 cellar: :any,                 catalina:       "1ba1e2980210accf42548e0eac13ad41469bd282a273e2a1d177dbb16e39e140"
    sha256 cellar: :any,                 mojave:         "05651d71e9f7fbb8f65b4f15e8037392bde8062ec8419535eaf4d213cacea3de"
    sha256 cellar: :any,                 high_sierra:    "8ca494e4c2131e0b9c9e02199a26998f7f14e47cf00da9fbe7a5e75891d5fb94"
    sha256 cellar: :any,                 sierra:         "a7d1777cff7684385a5a7d9c524a26e6f6509c80a638fadc99b6db84b96b1636"
    sha256 cellar: :any,                 el_capitan:     "423a279278962dbc33e3e7ec0d7e9e81d497c7c69d7b4f24860630ae9c55b7a1"
    sha256 cellar: :any,                 yosemite:       "82b3b35c9aae9cbcfe6502489d04ec44a478d058261e8456cba79f791da70a92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "674c3b2f45bedb504b062b8f4f17af5085908d4f956932c6bc19c334d98a8991"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "jpeg"
  depends_on "libexif"

  def install
    system "./autogen.sh", "--disable-debug",
                           "--disable-dependency-tracking",
                           "--disable-silent-rules",
                           "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/epeg", "--width=1", "--height=1", test_fixtures("test.jpg"), "out.jpg"
    assert_predicate testpath/"out.jpg", :exist?
  end
end
