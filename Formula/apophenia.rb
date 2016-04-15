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
    # write a sample csv text file to import
    (testpath/"foo").write("thud,bump")
    (testpath/"foo").write("1,2")
    # test the csv to sqlite importer (built with libapophenia) works
    system "#{bin}/apop_text_to_db", "foo", "bar", "baz"
    system "echo", ".dump", "bar", "|", "sqlite3", "baz"
    # test the graph plotting tool (built with libapophenia) works
    system "#{bin}/apop_plot_query", "-d", "baz", "-q", "select thud,bump from bar", "-f", "grumble"
  end
end
