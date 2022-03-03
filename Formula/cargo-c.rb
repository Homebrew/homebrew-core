class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.9.8.tar.gz"
  sha256 "7c649061826e0ad3c2c8735718f4a0c4afd12eed9b9fdc5fe59e34582902e1c5"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8ed31bb1d049368df58e032dfa4bce2b5bbcf70adb2824c280273a775612c07e"
    sha256 cellar: :any,                 arm64_big_sur:  "9a7f1fb3bf0bd8291b6f164ccd30970dd8e9592a7abdc7751d97858ae4118651"
    sha256 cellar: :any,                 monterey:       "188187590ff6acbf785185550f9ad65a0346535fdaa759c6be57233d108ad0da"
    sha256 cellar: :any,                 big_sur:        "fc3a915a471d510ad05b37ada973179c757dc0876537242b4ded7ce2a67d64f6"
    sha256 cellar: :any,                 catalina:       "131e982a3ac8083a21592029f8517bb15c3b242f67b297948bb587db11cf7c20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de230a696aa8edc8da8119ab824595ca8f89946708043de9ac77d61934f32ef1"
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
