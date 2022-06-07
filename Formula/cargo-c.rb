class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.9.10.tar.gz"
  sha256 "e4ad4f6459522b4b1f485c2637f328f267b81bc46fdd85ec9ddbf011aa7873eb"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "cd7e5e406134c55465d185abfb7e402775bb39942ada911d774279cd2ec2ad33"
    sha256 cellar: :any,                 arm64_big_sur:  "b17f42b897dfd5837663a9abaa449add07c681b555899d7879a637a9cc84ab7a"
    sha256 cellar: :any,                 monterey:       "fae0a554e9a610387f11e16688fc36b2353078c45ef7384b017e469f063f5f36"
    sha256 cellar: :any,                 big_sur:        "7c55b6a8daed03b2fe704447e224e6d005eafea0d3bc221b157fee08dab6f12d"
    sha256 cellar: :any,                 catalina:       "aea4a79c133b8c378009abbef294259af4e4cdbf0882b44195546a57c17a026a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffd63eb65c9f6d1174b5915bb67b8bcc21c024d5c8cba368cf55a5298226a1e4"
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
