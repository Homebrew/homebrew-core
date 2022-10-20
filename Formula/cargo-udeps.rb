class CargoUdeps < Formula
  desc "Find unused dependencies in Cargo.toml"
  homepage "https://github.com/est31/cargo-udeps"
  url "https://github.com/est31/cargo-udeps/archive/refs/tags/v0.1.34.tar.gz"
  sha256 "957034fad718cace7594ad072812db138787bfcf0749a091db809588dcfc3a05"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6d6845df1ba34370c3b9fa0c7b769847aa6cb745ee88545ed1efaf221fc20867"
    sha256 cellar: :any,                 arm64_big_sur:  "faa69a6ef582697317d33915cea601728d53fbaaba09497a0bc1b96c26308e8c"
    sha256 cellar: :any,                 monterey:       "cfcc243896eb4d948935368e87fda1241e98cf8a675accca000d4b8689372ca4"
    sha256 cellar: :any,                 big_sur:        "94b11ce62f5f1ba679b5e1dc55363b64ee71460b57305fbb6c274f7bf659c824"
    sha256 cellar: :any,                 catalina:       "8e31981fd45d83280a2c138d271e906b353af8d409fbe06563cebc34fb306587"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aec5abd367c1d5bdc4ee0c4ef834d662b730ed9b8cfe5472d45e827a9438efe4"
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
