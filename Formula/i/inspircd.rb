class Inspircd < Formula
  desc "Modular C++ Internet Relay Chat daemon"
  homepage "https://www.inspircd.org/"
  url "https://github.com/inspircd/inspircd/archive/refs/tags/v4.9.0.tar.gz"
  sha256 "7bbc0bd0b17d99cf3343005310183885b3d2210e386729fe7f0d7b81ec88c04d"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "0a11881e997b3a7081c32ac81997eff669d9a095308c3acdf739a8f9ae72f147"
    sha256 arm64_sequoia: "726ea94df5e2bdc9c01303ef5fcc8ce925ae6a6ee0530fefa374c736101bfd7b"
    sha256 arm64_sonoma:  "b9bb351cd635f4a3fc7df175fcaafa9a3da96a1302aeba38abc063979e4f3622"
    sha256 sonoma:        "8ceefe65a8e19894ee592e38c5c0402dab4bc3ada94efb9b1dae5623a7aa16eb"
    sha256 arm64_linux:   "ec40abcb3387a8b0aef724867a40e9ccadcc4646e158e38d2fbca73e59656e4b"
    sha256 x86_64_linux:  "2550979ff57ed3a71bfeea1a5f32d4f008c678d1a0924544d1af59219b024930"
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
