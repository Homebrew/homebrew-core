class Hqx < Formula
  desc "Magnification filter designed for pixel art"
  homepage "https://github.com/grom358/hqx"
  url "https://github.com/grom358/hqx.git",
      :tag      => "v1.2",
      :revision => "124c9399fa136fb0f743417ca27dfa2ca2860c2d"

  bottle do
    cellar :any
    sha256 "557085364f580e05f98df85ba471d686563820c1cf4b890c8c577ea1a1ac6e27" => :mojave
    sha256 "efdbc80364955ad0c66fe7729d298affb7644a72ee780012ad99f506088aedf9" => :high_sierra
    sha256 "2925d0405549e466e967124d8192e88a27a83b8b4619e88e9b5b1a109eb4e7ac" => :sierra
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
