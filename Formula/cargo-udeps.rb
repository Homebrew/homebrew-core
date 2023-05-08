class CargoUdeps < Formula
  desc "Find unused dependencies in Cargo.toml"
  homepage "https://github.com/est31/cargo-udeps"
  url "https://github.com/est31/cargo-udeps/archive/refs/tags/v0.1.39.tar.gz"
  sha256 "6542c2fed71ac8b416a0f41f94ec1402785d8ade34bfe5f228bb7ea76aed6b5a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f07f9ba44956f3bf9eb2c21d5ce40f1565ddad0d0b891edfab3768b5ac7af6be"
    sha256 cellar: :any,                 arm64_monterey: "8e8d2c9a5ba0432ced6ef51853b7562949c0b6a85a8e1bc348fbf7e10436e8c6"
    sha256 cellar: :any,                 arm64_big_sur:  "7f2b4df0655507eef94a916db530820fa20d08106db8e0ee4fde3341a31e1d0a"
    sha256 cellar: :any,                 ventura:        "4c1b8d82814f4afcc3986d6db97fab8250609d107d2145d53c7c8f1b59112b18"
    sha256 cellar: :any,                 monterey:       "f0136fde49ed8a8ed59d7a229e227a04496ce4e0b9783dfecfbfffbfe574a92a"
    sha256 cellar: :any,                 big_sur:        "5b32838889e1b801326583c3ba0cf723827f93f5543862f6bdb4a5fdd03aae9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e6160f1c819a77b18b6e943fa5b27392ec5e56da405b5d4442b502821b87a75"
  end

  depends_on "rust" => [:build, :test]
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write "// Dummy file"
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [dependencies]
        clap = "3"
      EOS

      output = shell_output("cargo udeps 2>&1", 101)
      # `cargo udeps` can be installed on Rust stable, but only runs with cargo with `cargo +nightly udeps`
      assert_match "error: the option `Z` is only accepted on the nightly compiler", output
    end
  end
end
