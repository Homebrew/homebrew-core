class CargoUdeps < Formula
  desc "Find unused dependencies in Cargo.toml"
  homepage "https://github.com/est31/cargo-udeps"
  url "https://github.com/est31/cargo-udeps/archive/refs/tags/v0.1.34.tar.gz"
  sha256 "957034fad718cace7594ad072812db138787bfcf0749a091db809588dcfc3a05"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6622fdf828e57a6e4d749fad4d44a1cc85c3726fabf3ce61ae7902e89b7b6044"
    sha256 cellar: :any,                 arm64_big_sur:  "ddc8518c0bf3e0363a2a389fe470017e6bdc5c5f4781a45b1a7cd9a077497bb2"
    sha256 cellar: :any,                 monterey:       "334d045c02dac51558977d168e54beb54580c7fcbaa1e9510647eb0112200746"
    sha256 cellar: :any,                 big_sur:        "468850dca51c19cbc95cffa5cebe480fabbb0a32861fd2a416b2583f23a92ee5"
    sha256 cellar: :any,                 catalina:       "6a7ae7defe85b4b9093732898f78fc63fb4f2af4fba90bcfa2ce5b86ea0e6156"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5975f26e35609000803541b719600c7043dfee1fc9fd0a0130ad2c46ba00b60d"
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
