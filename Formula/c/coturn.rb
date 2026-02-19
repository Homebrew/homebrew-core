class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "https://github.com/coturn/coturn/archive/refs/tags/4.8.0.tar.gz"
  sha256 "a3b302b52c5405a2595f59036c95fc3676e640436ba67e3f621937ec648b1ea5"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "d38701f1c1c672a30bc5d42ef428b4c5efa22418d12e27bf94e78bf6c904f06a"
    sha256                               arm64_sequoia: "8024d055cf20ac67e1a163583b340eb889d8b2cd83ced4e2650aec94855064e8"
    sha256                               arm64_sonoma:  "58b8abbe7590b12749b3f10f66933e7a3dc8b685de56b2c346a725463def2881"
    sha256 cellar: :any,                 sonoma:        "65262816d66456297922be972a056f6b8ec36e56be68c3137c07bb835371177b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22832cccdf52b5ab2f1e05c3ca72626a13f0efb2c47daa8fcf1997dda97f9569"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9095996248a3877188d93bb39b4b37c73ab303f4bd0f3e7c8c65eb501ce94cb3"
  end

  depends_on "pkgconf" => :build
  depends_on "hiredis"
  depends_on "libevent"
  depends_on "libpq"
  depends_on "openssl@3"

  def install
    ENV["SSL_CFLAGS"] = "-I#{Formula["openssl@3"].opt_include}"
    ENV["SSL_LIBS"] = "-L#{Formula["openssl@3"].opt_lib} -lssl -lcrypto"
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
