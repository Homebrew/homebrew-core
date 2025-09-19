class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https://www.inspircd.org/"
  url "https://github.com/inspircd/inspircd/archive/refs/tags/v4.8.0.tar.gz"
  sha256 "a1074f0ba2543718224e6041abd87cc1d9a4bf035417ccc589fa7f2dc28a8f3d"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "7f3a2e7036192c1097e80516f4da36d44944ae4158282f1dca7cbc7efb4ad0ab"
    sha256 arm64_sequoia: "fddcdf612c3d171cd0a06689f06d36a7055fce3cd8f43847fc84f6524a5abd72"
    sha256 arm64_sonoma:  "ab636811a3fd7a79be6ea1fe54d35c3f05c01d18f16cf7143bca7870ddd5eb62"
    sha256 arm64_ventura: "e91ee9ac4cf77dbe11f4b5a2bd678ca73a084487144e2da98cc3b0a21bfbeff1"
    sha256 sonoma:        "19af4125653b4db2c9d29fe8673ebed069b271387156ed8084be1c3eee1524a6"
    sha256 ventura:       "7a9c758724d097986665aca53d59a3636198419f999a0a8edd2610a43fab510d"
    sha256 arm64_linux:   "7b7d2bcc0f7ce924a5ba3f706193cb8129e0743bd92b3d0d4978d63762b651c5"
    sha256 x86_64_linux:  "7b24e31df85d715d73762549d821623bc897b319138ede550315c9e2b856072d"
  end

  depends_on "pkgconf" => :build
  depends_on "argon2"
  depends_on "gnutls"
  depends_on "libpq"
  depends_on "mariadb-connector-c"

  uses_from_macos "openldap"

  skip_clean "data"
  skip_clean "logs"

  def install
    ENV.cxx11
    system "./configure", "--enable-extras",
                          "argon2 ldap mysql pgsql regex_posix ssl_gnutls sslrehashsignal"
    system "./configure", "--disable-auto-extras",
                          "--distribution-label", "homebrew-#{revision}",
                          "--prefix", prefix
    system "make", "install"
  end

  test do
    assert_match("ERROR: Cannot open config file", shell_output(bin/"inspircd", 1))
  end
end
