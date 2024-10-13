class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https://www.inspircd.org/"
  url "https://github.com/inspircd/inspircd/archive/refs/tags/v4.3.0.tar.gz"
  sha256 "b9b306281238377747ce030749e1ae338a737a45bd1fde4e8d8b9f694299f57e"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia:  "0d4d6b5603c1afef4fe0bec89128310d80abd97bcbd386b161f321a008dff134"
    sha256 arm64_sonoma:   "6d5b419638b4cd48395de81d585dabf6703acd7c80d2eb600638e950c893fc36"
    sha256 arm64_ventura:  "1ad12aaa5c0fa1d3375f92a581f3415efe57c573d03f47b439c1776634a3e838"
    sha256 arm64_monterey: "23597df57c83b56bf24c0cfea5842169aa367b1357af5a43555336ecc6942082"
    sha256 sonoma:         "ca55e09a1296bf509613a2f5c78a9edf040c487586a79ec2567fee16412cf771"
    sha256 ventura:        "57bc4ce7d9caf8b8c44dc9083987b6ca4ee3d99b13ed92b6ab79acb579044488"
    sha256 monterey:       "661beb7894b6d7aa7aa310998462725d7c0971ec831c3149fb0c61b04d885134"
    sha256 x86_64_linux:   "30c85c857954d4de73fb4273978d7ee7a18159578cb4d2b387b3305cb8ca190f"
  end

  depends_on "pkg-config" => :build
  depends_on "argon2"
  depends_on "gnutls"
  depends_on "libpq"
  depends_on "mysql-client"

  uses_from_macos "openldap"

  on_macos do
    depends_on "openssl@3"
    depends_on "zlib"
    depends_on "zstd"
  end

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
