class Lftp < Formula
  desc "Sophisticated file transfer program"
  homepage "https://lftp.yar.ru/"
  url "https://lftp.yar.ru/ftp/lftp-4.9.2.tar.xz"
  sha256 "c517c4f4f9c39bd415d7313088a2b1e313b2d386867fe40b7692b83a20f0670d"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/lavv17/lftp.git"
  end

  bottle do
    sha256 "a388da5bb2e5beee32d122f71ae93a0d000af5d00b6ff40428d7e113ce123471" => :catalina
    sha256 "db1429c68ffecc6a300d1adbcb980425c95a3d92112d1f4b69a148fe09bad066" => :mojave
    sha256 "d92a86e574d3660a49de510815a7780708606fef9f498d5376ee91d2d61956f8" => :high_sierra
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
