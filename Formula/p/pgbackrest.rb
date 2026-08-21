class Pgbackrest < Formula
  desc "Reliable PostgreSQL Backup & Restore"
  homepage "https://pgbackrest.org"
  url "https://github.com/pgbackrest/pgbackrest/releases/download/release/2.59.1/pgbackrest-2.59.1.tar.gz"
  sha256 "1cd522afc33b8ff846ef88c55dc238717c9c8817a4f6ca7c9f64887de9c7402d"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a5b4d48f2e957999ad4cb76044996ff5ece07184115158cae866458709d1bf32"
    sha256 cellar: :any, arm64_sequoia: "39a0c873cd9b601b37576b4bb9c5d25cef05c0e3bdf9fa00baede5f1177b8cc7"
    sha256 cellar: :any, arm64_sonoma:  "24429a2d290d2cc0837e9a27461c1f4850fc96f7cfcf89b583f19077f5220528"
    sha256 cellar: :any, sonoma:        "0caf27c803755915597c4d0bf7cd134d2acbd819e92613af102c8e65f674c1c8"
    sha256               arm64_linux:   "65dc1e3b628ea02949fdd84c54dbc8baf5ef16dbd3f8471ad7aeca8f156850ac"
    sha256               x86_64_linux:  "cb3ddfd48f3fecad5d831caf196c6e8e6c7906fec5e71811490af643c24bb778"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "libpq"
  depends_on "libssh2"
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath(target: formula_opt_lib("libpq"))}" if OS.linux?

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    output = shell_output("#{bin}/pgbackrest info")
    assert_match "No stanzas exist in the repository.", output
  end
end
