class Check < Formula
  desc "C unit testing framework"
  homepage "https://libcheck.github.io/check/"
  url "https://github.com/libcheck/check/releases/download/0.14.0/check-0.14.0.tar.gz"
  sha256 "bd0f0ca1be65b70238b32f8e9fe5d36dc2fbf7a759b7edf28e75323a7d74f30b"

  bottle do
    cellar :any
    sha256 "c6adc313137a97331bebce862758d1235f590c37bfc855920f953edf858c8d85" => :catalina
    sha256 "244b4b72dfed2d2950e3f3183e8d3a1207fef62470643097402dbf34b5223303" => :mojave
    sha256 "b61bb914f053c31a8dcb86394d10d3e3b77b2d71ebe2c4f21585f05f15594d8e" => :high_sierra
  end

  uses_from_macos "gawk"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.tc").write <<~EOS
      #test test1
      ck_assert_msg(1, "This should always pass");
    EOS

    system "#{bin/"checkmk"} test.tc > test.c"

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcheck", "-o", "test"
    system "./test"
  end
end
