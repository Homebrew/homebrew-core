class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.7.2.tar.gz"
  sha256 "d27e025b24b69dabf4cd1bd1fca7d2a78fe111688bfea6e54718b99009861db4"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c0e0c644ee47ba7deb9c7eceb42ac4c4d0b7012d858b67b9693b05c1c468bb17"
    sha256 cellar: :any, big_sur:       "f9a60b7749bed707c76733703678293cc182f0e32182ce653c86e2a6e493e196"
    sha256 cellar: :any, catalina:      "b0676ac504a98f9a47e0668ed26f9717bf7f6ffd6f4fc05e7fa831dbb84e0cc4"
    sha256 cellar: :any, mojave:        "242d6e1d8ffba868043ff830eadec61d1f39f12068a2d26101dcfaf18b2b19d8"
  end

  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@1.1"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    cargo_error = "could not find `Cargo.toml`"
    assert_match cargo_error, shell_output("#{bin}/cargo-cinstall cinstall 2>&1", 1)
    assert_match cargo_error, shell_output("#{bin}/cargo-cbuild cbuild 2>&1", 1)
  end
end
