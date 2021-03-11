class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https://www.inspircd.org/"
  url "https://github.com/inspircd/inspircd/archive/v3.9.0.tar.gz"
  sha256 "5bda0fc3d41908cda4580de39d62e8be4840da45f31e072cfca337b838add567"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url "https://github.com/inspircd/inspircd.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "6b507d03991070797eeaad12dcddd01f9e4998f220a271e5ce4e1cb4d169c585"
    sha256 big_sur:       "0caaf6178d051e67e410280bfd012c55ae959466ff777f3bb0bb61365d7eb49b"
    sha256 catalina:      "e7398c29b76c7e3186f9d649adc17bf0915d3d352063a089b6c85dddfbdd98c5"
    sha256 mojave:        "803d67a8546b753df6bcd5b11da70c4bd00cd963e5517af4620696368880b0a7"
  end

  depends_on "pkg-config" => :build
  depends_on "argon2"
  depends_on "gnutls"
  depends_on "libpq"
  depends_on "mysql-client"

  uses_from_macos "openldap"

  skip_clean "data"
  skip_clean "logs"

  def install
    system "./configure", "--enable-extras",
                          "argon2 ldap mysql pgsql regex_posix regex_stdlib ssl_gnutls sslrehashsignal"
    system "./configure", "--disable-auto-extras",
                          "--distribution-label", "homebrew-#{revision}",
                          "--prefix", prefix
    system "make", "install"
  end

  test do
    assert_match("ERROR: Cannot open config file", shell_output("#{bin}/inspircd", 2))
  end
end
