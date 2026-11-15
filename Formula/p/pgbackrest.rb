class Pgbackrest < Formula
  desc "Reliable PostgreSQL Backup & Restore"
  homepage "https://pgbackrest.org"
  url "https://github.com/pgbackrest/pgbackrest/releases/download/release/2.60.0/pgbackrest-2.60.0.tar.gz"
  sha256 "6d3ee1b5defdadc85228969b4be804096f5e65e54707bb95c7c4c4ce41f5d007"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "95df2decd2f9e146cd3de3fd0bbd94a0b073ae714490b6834a40679541bb60f5"
    sha256 cellar: :any, arm64_tahoe:       "67dfc0e88fc5a7b8bce77d2d128037282c6e1144382fb233a9b52cac735ff082"
    sha256 cellar: :any, arm64_sequoia:     "5657bc628b3b017db202ee0a63367966def23331dec49cc70519eb1efda014eb"
    sha256 cellar: :any, arm64_linux:       "b51c10b3274577fc6b828a352658c42ebb3e048155eb9881888eb895bbe0052f"
    sha256 cellar: :any, x86_64_linux:      "36a0dce8a41f209795b30592560815aa9bba7342b4d47abe54ae6f6cbffa2a19"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "libpq"
  depends_on "libssh2"
  depends_on "lz4"
  depends_on "openssl@4"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

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
