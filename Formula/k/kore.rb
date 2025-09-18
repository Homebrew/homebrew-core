class Kore < Formula
  desc "Web application framework for writing web APIs in C"
  homepage "https://kore.io/"
  url "https://kore.io/releases/kore-4.2.3.tar.gz"
  sha256 "f9a9727af97441ae87ff9250e374b9fe3a32a3348b25cb50bd2b7de5ec7f5d82"
  license "ISC"
  head "https://github.com/jorisvink/kore.git", branch: "master"

  livecheck do
    url "https://kore.io/source"
    regex(/href=.*?kore[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:    "059c350956eced72b4ef7d31a358fac3e5df1b7132fabad051c2fef4a9f55c34"
    sha256 arm64_sequoia:  "b25dd99e236b7cf5cdfec8d1128dfb125d271400aef79e29a6877fd47f86a4a2"
    sha256 arm64_sonoma:   "d984004ecf128c881234240035fe13f5e2c9af10c9bb0552f4ee0a321d2f5bdb"
    sha256 arm64_ventura:  "2079b1a823ee0915cb18e0148f04514d04638dc91807d2b3ef27c32129f7303a"
    sha256 arm64_monterey: "0a22c98bd62f85f7cb1dcd41ef763c95bb97c4d77592432770de250e97dde75c"
    sha256 arm64_big_sur:  "37860487cb7c2ec1efeb924857b32da30d3bd6dd07f7eff4da3ad42d24134252"
    sha256 sonoma:         "87b0774ca1be1fadbe6353582a6af3fc01e53e80f31891fc152458584e3ac9b0"
    sha256 ventura:        "a826de0cab4f5e9b7cef6d7a08573d38b476cefda028e3ace20a8c1b79b7d414"
    sha256 monterey:       "4a013753ae526626e4afd5519a41521c5c2e2a004b741306617b7d23f6c7b218"
    sha256 big_sur:        "13917b8cf36d5fb5b57fb5028aa49fd421bd4ec930742b697d194ee0c0e1bb21"
    sha256 arm64_linux:    "38438db7080ee244c41fb90a46e7515d73171187f3e2ea7bc8a6c6b26277dda9"
    sha256 x86_64_linux:   "8f982ba054916139a8560c8826a450b30784e08c672aaebcc8736d6ca88e4eb0"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"

  def install
    openssl = Formula["openssl@3"]

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
