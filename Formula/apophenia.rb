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
    (testpath/"foo.csv").write <<-EOS.undent
      thud,bump
      1,2
      3,4
      5,6
      7,8
    EOS
    # test the csv to sqlite importer (built with libapophenia) works
    system "#{bin}/apop_text_to_db", (testpath/"foo.csv"), "bar", (testpath/"baz.db")
    system "echo", ".dump", "bar", "|", "sqlite3", (testpath/"baz.db")
    # test the graph plotting tool (built with libapophenia) works
    system "#{bin}/apop_plot_query", "-d", (testpath/"baz.db"), "-q", "select thud,bump from bar", "-f", "grumble"
  end
end
