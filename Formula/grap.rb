class Grap < Formula
  desc "Language for typesetting graphs"
  homepage "https://www.lunabase.org/~faber/Vault/software/grap/"
  url "https://www.lunabase.org/~faber/Vault/software/grap/grap-1.46.tar.gz"
  sha256 "7a8ecefdecfee96699913f2a412da68703911fa640bac3b964a413131f848bb4"

  bottle do
    sha256 "8eb83388db58c42ae00a343e1382c52948c5b203ff754fed7b6582eeb989fa3c" => :catalina
    sha256 "d7f05f3fc8eb5c0c3f3a5a66bf4d43262a84ae1edaf7ec92897122fd069e4a96" => :mojave
    sha256 "b7394034b2898da9e7a61d578f9789f642f29d3191f84041b4fb9763bdfdcc73" => :high_sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-example-dir=#{pkgshare}/examples"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    (testpath/"test.d").write <<~EOS
      .G1
      54.2
      49.4
      49.2
      50.0
      48.2
      43.87
      .G2
    EOS
    system bin/"grap", testpath/"test.d"
  end
end
