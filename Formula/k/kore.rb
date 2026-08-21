class Kore < Formula
  desc "Web application framework for writing web APIs in C"
  homepage "https://kore.io/"
  url "https://kore.io/releases/kore-4.2.3.tar.gz"
  sha256 "f9a9727af97441ae87ff9250e374b9fe3a32a3348b25cb50bd2b7de5ec7f5d82"
  license "ISC"
  revision 1
  head "https://github.com/jorisvink/kore.git", branch: "master"

  livecheck do
    url "https://kore.io/source"
    regex(/href=.*?kore[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "3147b297014a79e06b6a7ee03cbeab03736d02b1d94fd2886263309e79426aad"
    sha256 arm64_sequoia: "89189fa27de08b5e348fe2fade868237614af312b3e5793d265d3317df0f176e"
    sha256 arm64_sonoma:  "75c9eb9e12ca1023275eeb0517dddbcd88c1acc2435b601f373a408c3308f997"
    sha256 sonoma:        "be43b043c4baa1ce0094c7a071b9ab0e6a690a01b0b7b643ecfd3c7ea77029fe"
    sha256 arm64_linux:   "9b465cc894bb5c79b694074b46492285b9890bd684e7a7b7b856841e16598a61"
    sha256 x86_64_linux:  "71c449df397bf69830432c1cc213c428b6211a1bb3fe551279036d55ab9ca1a5"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@4"

  def install
    openssl = Formula["openssl@4"]

    # We modify Makefile variables to save OpenSSL paths which get used at runtime.
    # We don't directly override FEATURES_INC as Makefile uses 'FEATURES_INC+='.
    # This is not needed on macOS where the Makefile already saves pkg-config output.
    unless OS.mac?
      inreplace "Makefile", /^FEATURES_INC=$/, "FEATURES_INC=-I#{openssl.opt_include}"
      ENV["OPENSSL_PATH"] = openssl.opt_prefix
    end

    ENV.deparallelize { system "make", "PREFIX=#{prefix}", "TASKS=1" }
    system "make", "install", "PREFIX=#{prefix}"

    # Remove openssl cellar references, which breaks kore on openssl updates
    inreplace [pkgshare/"features", pkgshare/"linker"], openssl.prefix.realpath, openssl.opt_prefix if OS.mac?
  end

  test do
    system bin/"kodev", "create", "test"
    cd "test" do
      system bin/"kodev", "build"
      system bin/"kodev", "clean"
    end
  end
end
