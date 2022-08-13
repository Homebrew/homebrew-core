class CargoUdeps < Formula
  desc "Find unused dependencies in Cargo.toml"
  homepage "https://github.com/est31/cargo-udeps"
  url "https://github.com/est31/cargo-udeps/archive/refs/tags/v0.1.30.tar.gz"
  sha256 "a1dd8b533fa915783919b78705d4a377fb021b67f8386023866017a139caf935"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8c7e006cb049e371afab1a3257a04927618f879712320f8dd1e594de14a5c423"
    sha256 cellar: :any,                 arm64_big_sur:  "8ac32a45c4f270ff2086ee67f3c0c9d1aed6b4bbaaaf35de024330c4f0a81d92"
    sha256 cellar: :any,                 monterey:       "208a877aeaf835e33c3ffb727bae9656921e401976aa51455c913b0d6a2b3713"
    sha256 cellar: :any,                 big_sur:        "8dbe2ba1c06246158c9c2afde166d3d9a6171896752fb4f3b71c6512c2667496"
    sha256 cellar: :any,                 catalina:       "25669c49fab35c58d74a0378a7e5e1692a6ec1f71bbc0a385c8704ac1f3786e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "683e4363ea5f54a95ce6dceb70a187eb2850c8b21d3997959bd0cd50e4927732"
  end

  depends_on "rust" => [:build, :test]
  depends_on "openssl@1.1"

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
