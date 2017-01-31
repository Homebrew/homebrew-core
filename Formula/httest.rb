class Httest < Formula
  desc "Provides a large variety of HTTP-related test functionality."
  homepage "http://htt.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/htt/htt2.4/httest-2.4.12/httest-2.4.12.tar.gz"
  sha256 "fd18cdc996c199d56d77e9355c07e1e1701d5550c03fbecb06a255ce72d79bd1"

  depends_on "apr"
  depends_on "apr-util"
  depends_on "openssl"
  depends_on "pcre"
  depends_on "lua"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-apr=#{Formula["apr"].opt_prefix/"bin"}",
                          "--with-lua=#{Formula["lua"].opt_prefix}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"

    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.htt").write <<-EOS.undent
      CLIENT 5
        _TIME time
      END
    EOS
    system bin/"httest", "--debug", testpath/"test.htt"
  end
end
