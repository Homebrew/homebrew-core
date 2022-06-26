class Lftp < Formula
  desc "Sophisticated file transfer program"
  homepage "https://lftp.yar.ru/"
  url "https://lftp.yar.ru/ftp/lftp-4.9.2.tar.xz"
  sha256 "c517c4f4f9c39bd415d7313088a2b1e313b2d386867fe40b7692b83a20f0670d"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://github.com/lavv17/lftp.git"
  end

  bottle do
    sha256 arm64_monterey: "823b7c535f6ddb59475a35e3e1547396e342564bcf06bbb2aab7e6d5375957a7"
    sha256 arm64_big_sur:  "c6e871000f9337c8fa0d56ff9b345209c13449be17e00e4e0248deeae3fd589f"
    sha256 monterey:       "2a442a45b5762f4e73a2a70bb51742d40ee3519d92bf215b3baf6e014aa4dc68"
    sha256 big_sur:        "68cdb9b693cf4ea5b7a8c9c0cdd02a2a2eb391c78df5e657767a59819dcbd9af"
    sha256 catalina:       "16e629365517da3f55e271f5e55c1d8ae759b5f2a2d7df669b87e93e05b948f9"
    sha256 mojave:         "7165e8f2ed29e55cc2cb819961d167fb7da7c8ebba7ababf4475c792b6f29afb"
    sha256 x86_64_linux:   "0161820813581ff31e0e0cdf09830dad364357f874ad570bb67db570ab589b98"
  end

  depends_on "libidn2"
  depends_on "openssl@1.1"
  depends_on "readline"

  uses_from_macos "zlib"

  def install
    # Work around "error: no member named 'fpclassify' in the global namespace"
    if MacOS.version == :high_sierra
      ENV.delete("HOMEBREW_SDKROOT")
      ENV.delete("SDKROOT")
    end

    # Work around configure issues with Xcode 12
    # https://github.com/lavv17/lftp/issues/611
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}",
                          "--with-libidn2=#{Formula["libidn2"].opt_prefix}"

    system "make", "install"
  end

  test do
    system "#{bin}/lftp", "-c", "open https://ftp.gnu.org/; ls"
  end
end
