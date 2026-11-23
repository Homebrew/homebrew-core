class IcWasm < Formula
  desc "CLI tool for performing Wasm transformations specific to ICP canisters"
  homepage "https://github.com/dfinity/ic-wasm"
  url "https://github.com/dfinity/ic-wasm/archive/refs/tags/1.0.0.tar.gz"
  sha256 "336d5414f13490b5e1756b09dd1a9d07a16c46068d17df4f3e0e96f55ebf3796"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    manifest_sha256 "66e5d46341a76eca98818daaa23a22bd8700425b9a8e66592fe601e00ee3c010"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2f8f304eff9b781bb7709a8ab395c2c6088a430cfd65191c0b34c52c92635580"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2b46b38a7b21528136d92f49c0077736f613316bd622e214c105e7a3074c93e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0a042fc2ab03f4316a854a78e50a1842c06635ce78e1869042ad782f59b5024d"
    sha256 cellar: :any,                 arm64_linux:       "3f8962cb42b765cbc45c8c7b0fc506929fed415d9ebc368954bfc43c05df3fab"
    sha256 cellar: :any,                 x86_64_linux:      "a24d6e76d1e2254c232661dae4e246ba104159d122bea7db1bf4c3595e79ebb2"
  end

  depends_on "rust" => :build
  depends_on "wasm-tools" => :test

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Create a wasm module with a custom section for ICP metadata
    (testpath/"test.wat").write '(module (@custom "icp:public abc" "def"))'
    system "wasm-tools", "parse", "test.wat", "-o", "test.wasm"

    # Verify ic-wasm can read the metadata
    assert_equal "def", shell_output("#{bin}/ic-wasm test.wasm metadata abc").strip
  end
end
