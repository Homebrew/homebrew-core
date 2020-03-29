class Lftp < Formula
  desc "Sophisticated file transfer program"
  homepage "https://lftp.yar.ru/"
  url "https://lftp.yar.ru/ftp/lftp-4.9.1.tar.xz"
  sha256 "5969fcaefd102955dd882f3bcd8962198bc537224749ed92f206f415207a024b"

  bottle do
    sha256 "88341463e443203acace85f22c68bfecc1e374e97c3bc61a4d55992a7894dbdc" => :catalina
    sha256 "7fb04159e36521d586e023c99ac6f63d3a695e6043ae62645c68da964776eebc" => :mojave
    sha256 "54a5bfc00d589ffec053ceb367cb1acee8ad1d13a5549eeda097f9b3fb5c92e2" => :high_sierra
  end

  depends_on "libidn"
  depends_on "openssl@1.1"
  depends_on "readline"

  uses_from_macos "zlib"

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
