class Apophenia < Formula
  desc "C library for statistical and scientific computing"
  homepage "http://apophenia.info/"
  url "https://github.com/b-k/apophenia/archive/v1.0.tar.gz"
  sha256 "c753047a9230f9d9e105541f671c4961dc7998f4402972424e591404f33b82ca"

  depends_on "gsl"
  depends_on "sqlite"

  def install
    system "./configure", "--with-mysql=no", "--enable-extended-tests", "--prefix=#{prefix}"
    system "make", "-j"
    system "make", "install"
  end

  test do
    (testpath/"foo").write("1")
    system "#{bin}/apop_text_to_db", "foo", "bar", "baz"
  end
end
