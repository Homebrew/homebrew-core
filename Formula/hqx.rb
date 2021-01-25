class Hqx < Formula
  desc "Magnification filter designed for pixel art"
  homepage "https://github.com/grom358/hqx"
  url "https://github.com/grom358/hqx.git",
      tag:      "v1.2",
      revision: "124c9399fa136fb0f743417ca27dfa2ca2860c2d"
  license "LGPL-2.1"

  bottle do
    cellar :any
    rebuild 1
    sha256 "c3eaf1733b78849670e6b6c94e387cbe055f62135cfb4f5f2a9a9bb5b8e3a3aa" => :big_sur
    sha256 "85c3fd01d9455be7d4d7307056598d4079f1a40f31803184f0aaa0ec2a9fef5a" => :arm64_big_sur
    sha256 "5451336478301f3e489b4a550f24c2051f707ed4819c26637d630bf128ee7501" => :catalina
    sha256 "942372ef0cb87baf0b90f4ea932d4f1c9825765a8cf5e482c1b3df04b18c821d" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "devil"

  def install
    ENV.deparallelize
    system "autoreconf", "-iv"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"hqx", test_fixtures("test.jpg"), "out.jpg"
    output = pipe_output("php -r \"print_r(getimagesize(\'file://#{testpath}/out.jpg\'));\"")
    assert_equal <<~EOS, output
      Array
      (
          [0] => 4
          [1] => 4
          [2] => 2
          [3] => width="4" height="4"
          [bits] => 8
          [channels] => 3
          [mime] => image/jpeg
      )
    EOS
  end
end
