class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.9.14.tar.gz"
  sha256 "d79c12eae1460803a1ce8b440ae213dc4df63a6f2bf39ebd49eea1d7a008bec6"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "58535a65ea0401d9c1e87215600e04616c2d74f57cab0e672caafc0341db55c0"
    sha256 cellar: :any,                 arm64_monterey: "4c1767923a998bceb5c1a714c60e032b1b7e6c102ae9b8b539cdd406c2db2673"
    sha256 cellar: :any,                 arm64_big_sur:  "88d8b2fcfb6a38afcdbb803ffa2dc1e23419ee5b786c3e31f9a36d5f4d81da7f"
    sha256 cellar: :any,                 monterey:       "a77a74614bd407d853af72c599cee3c89ac1fdd22f7c8094e1907fbc1a4850b5"
    sha256 cellar: :any,                 big_sur:        "7a9f5d22006f074a97364d7bc501d6e5b39e982b9c9cd6ec55ce01ac4dd81d57"
    sha256 cellar: :any,                 catalina:       "96de6ff26a8e660c2984a1e1eb3177bb31ddc3601f00f68826986789f82b075f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7d7151c6fc8ec95bed248cea483f992307c50e14abdb024baaf1d4941b87530"
  end

  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

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
