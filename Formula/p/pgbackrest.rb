class Pgbackrest < Formula
  desc "Reliable PostgreSQL Backup & Restore"
  homepage "https://pgbackrest.org"
  url "https://github.com/pgbackrest/pgbackrest/releases/download/release/2.59.0/pgbackrest-2.59.0.tar.gz"
  sha256 "faaf8faa14a6392279654ee216a493fcd07b0c513af4b55fe34faec062cb8875"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4ea6629d80029f29b04edcc904d464cec785a66ae2271f7a50c44bb99ff1050b"
    sha256 cellar: :any, arm64_sequoia: "5b373f1453518944f54a6621e3bfed13b9bb9dbfdf21a85b7a14cf960ec35610"
    sha256 cellar: :any, arm64_sonoma:  "cdb012fbe9ec5eaec66b2540f65be5df78e22b99dc46371d1edfc55ef0726c5c"
    sha256 cellar: :any, sonoma:        "7ff1588401ffc1f4a13e8ba1fb23ce1de57f59722101af4a98943f0742747aba"
    sha256               arm64_linux:   "bf7b5e0d6705615a408a9b3a9dd772c3df5da9c9996bce8fedd91206bbf8d56c"
    sha256               x86_64_linux:  "109950aeb76edd47f3afbef9df6d90a631e16269195390eeb4ce90f1835f4acb"
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
