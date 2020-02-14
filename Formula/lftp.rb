class Lftp < Formula
  desc "Sophisticated file transfer program"
  homepage "https://lftp.yar.ru/"
  url "https://lftp.yar.ru/ftp/lftp-4.9.1.tar.xz"
  sha256 "5969fcaefd102955dd882f3bcd8962198bc537224749ed92f206f415207a024b"

  bottle do
    sha256 "fb5f0306c383dd4d19d406529aa15b5468080bbb11b22ef0de4b225cdd981a25" => :catalina
    sha256 "38f687b927d39fc37f4ff84e35086eeadde61826732b21bf3ec12b091b779fdc" => :mojave
    sha256 "bbf5aadf64bdf2e7334006c1a04512bd62417e4d74239db44f134fcd2e524d3c" => :high_sierra
  end

  depends_on "libidn"
  depends_on "openssl@1.1"
  depends_on "readline"

  def install
    # Work around "error: no member named 'fpclassify' in the global namespace"
    if MacOS.version == :high_sierra
      ENV.delete("HOMEBREW_SDKROOT")
      ENV.delete("SDKROOT")
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}",
                          "--with-libidn=#{Formula["libidn"].opt_prefix}",
                          # Work around a gnulib issue with macOS Catalina
                          "gl_cv_func_ftello_works=yes"

    system "make", "install"
  end

  test do
    system "#{bin}/lftp", "-c", "open https://ftp.gnu.org/; ls"
  end
end
