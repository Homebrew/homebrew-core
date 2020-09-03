class Kore < Formula
  desc "Web application framework for writing web APIs in C"
  homepage "https://kore.io/"
  url "https://kore.io/releases/kore-4.0.0.tar.gz"
  sha256 "c4f5629c9fca7ede7664063a318021f58c7909cbff822dad8dca88da7d9043c2"
  license "ISC"
  head "https://github.com/jorisvink/kore.git"

  bottle do
    sha256 "abbcf36f378af2db9914b9f6edf1a4e4808723a9d0421056bd6de645f5393dd2" => :catalina
    sha256 "760a9977cc46ad5f46e5d9b3397af22e0ff1df60e33acc622851d7a8babb2234" => :mojave
    sha256 "0c76cfc29a1c006207b09015550a0f33b5c54a1aaff542c1e8843a6531c083c8" => :high_sierra
    sha256 "719bd8b11d2757fec07aa6558c95c500f2a7b6148a0ebbf2563d1012dc4eece2" => :sierra
  end

  depends_on macos: :sierra # needs clock_gettime

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
