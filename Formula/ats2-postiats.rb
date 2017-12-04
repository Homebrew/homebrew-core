class Ats2Postiats < Formula
  desc "Programming language with formal specification features"
  homepage "http://www.ats-lang.org/"
  url "https://downloads.sourceforge.net/project/ats2-lang/ats2-lang/ats2-postiats-0.3.8/ATS2-Postiats-0.3.8.tgz"
  sha256 "834342be1e2af51a1d0b4151f4d76173946ab9424efcd27b11de17e9031201df"

  bottle do
    cellar :any
    sha256 "42478768ce3516ce46d82c0df9cb7499b96e39f5cb527d2fb1f3e04da40eda98" => :high_sierra
    sha256 "670a2c12297acc3627258522e925ee0b2cc47fd197cd78b970ba83b8ed06d581" => :sierra
    sha256 "dc9f99d784c8b80d3903af019f78d70e2552c7f17f064d76cbabf8c45e5eb9be" => :el_capitan
  end

  depends_on "gmp"

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
    system "make", "all", "install"
  end

  test do
    (testpath/"hello.dats").write <<~EOS
      val _ = print ("Hello, world!\n")
      implement main0 () = ()
    EOS
    system "#{bin}/patscc", "hello.dats", "-o", "hello"
    assert_match "Hello, world!", shell_output(testpath/"hello")
  end
end
