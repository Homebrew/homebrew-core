class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.9.0.tar.gz"
  sha256 "431824dee0b048877c625c5d61f03a60d40550711df25006e0543c5ec3f1e234"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "50560a7a61f88463803dda19ee0446821efb2eca8211f35de4dd5df90ff2d495"
    sha256 cellar: :any, big_sur:       "7207f1e1c83bc1a7fc64065dd5d5578579bbde36e1811dd625e759e15229208b"
    sha256 cellar: :any, catalina:      "dc5bab60bcb4f7ae6a18de5fa8e5130f97ef5792b6e6c435f8c9267c66fb8299"
    sha256 cellar: :any, mojave:        "878b3db491d968bf965f02cf83f277d6718bee3138015fdc895172259335f5c2"
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
