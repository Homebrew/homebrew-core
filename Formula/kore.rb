class Kore < Formula
  desc "Web application framework for writing web APIs in C"
  homepage "https://kore.io/"
  url "https://kore.io/releases/kore-3.3.1.tar.gz"
  sha256 "c80d7a817883e631adf9eb5271b4ffa6ebb06c2e2fca40ce6c3c75638c08b67a"
  revision 1
  head "https://github.com/jorisvink/kore.git"

  bottle do
    sha256 "6a95d524179a182edc173a57844b7a1da84c6ef8976cfbff7f547925b1fc642d" => :mojave
    sha256 "8570b9dab42658062561ea23228c151ba71de5f73d2d123227a7cd2c65cba16c" => :high_sierra
    sha256 "4eb2eb9964edaff6047fb3f6e81b4c6e735962b48f6f264ef35fe04e0a604f9f" => :sierra
  end

  depends_on :macos => :sierra # needs clock_gettime

  depends_on "openssl@1.1"

  def install
    # Ensure make finds our OpenSSL when Homebrew isn't in /usr/local.
    # Current Makefile hardcodes paths for default MacPorts/Homebrew.
    ENV.prepend "CFLAGS", "-I#{Formula["openssl@1.1"].opt_include}"
    ENV.prepend "LDFLAGS", "-L#{Formula["openssl@1.1"].opt_lib}"
    # Also hardcoded paths in src/cli.c at compile.
    inreplace "src/cli.c", "/usr/local/opt/openssl/include",
                            Formula["openssl@1.1"].opt_include

    system "make", "PREFIX=#{prefix}", "TASKS=1"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"kodev", "create", "test"
    cd "test" do
      system bin/"kodev", "build"
      system bin/"kodev", "clean"
    end
  end
end
