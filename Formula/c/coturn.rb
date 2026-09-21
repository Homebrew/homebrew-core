class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "https://github.com/coturn/coturn/archive/refs/tags/4.18.0.tar.gz"
  sha256 "28d55294ac596fbd129b293a85e7bb1c5dc4bd15b7fb55c500f355149e5f4e28"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "e00f609c7c4ad4e5d4cd928e766c5f9d09de2d80be6fa7dfd24323566f1be309"
    sha256 arm64_tahoe:       "7eef9f97ff58259aadf443c8b8b2f2bd12064409926d1b344d71ffccef301c6f"
    sha256 arm64_sequoia:     "a194b7650a640185c3dff9a8ae3b0a1fbec26bf8d39883c2fa36f038c5096f14"
    sha256 arm64_sonoma:      "8d5a78350d9d69255bcedffd1b8f2059638c56b1c9a276f27b519a2e1912b2ef"
    sha256 arm64_linux:       "6ca852a8e43f1e6f3a26ec32ca35d2a0740946eb0a16cb3104e12be990523501"
    sha256 x86_64_linux:      "41bd9ebac6e188018d7528b405e3d1f137e2fcec4c1d4bd2aea829977b21cbf9"
  end

  depends_on "pkgconf" => :build
  depends_on "hiredis"
  depends_on "libevent"
  depends_on "libpq"
  depends_on "openssl@3"

  uses_from_macos "sqlite"

  def install
    ENV["SSL_CFLAGS"] = "-I#{formula_opt_include("openssl@3")}"
    ENV["SSL_LIBS"] = "-L#{formula_opt_lib("openssl@3")} -lssl -lcrypto"
    system "./configure", "--disable-silent-rules",
                          "--mandir=#{man}",
                          "--localstatedir=#{var}",
                          "--includedir=#{include}",
                          "--docdir=#{doc}",
                          *std_configure_args

    system "make", "install"

    man.mkpath
    man1.install Dir["man/man1/*"]
  end

  service do
    run [opt_bin/"turnserver", "-c", etc/"turnserver.conf"]
    keep_alive true
    error_log_path var/"log/coturn.log"
    log_path var/"log/coturn.log"
    working_dir HOMEBREW_PREFIX
  end

  test do
    system bin/"turnadmin", "-l"
  end
end
