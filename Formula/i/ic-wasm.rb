class IcWasm < Formula
  desc "CLI tool for performing Wasm transformations specific to ICP canisters"
  homepage "https://github.com/dfinity/ic-wasm"
  url "https://github.com/dfinity/ic-wasm/archive/refs/tags/0.9.11.tar.gz"
  sha256 "579e8085c33b7cf37ed2ddc3b9a34dca5dca083201f7648c5d636bab80f75258"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f0f9431b78c9425870ccd321f68d572bf229c7878bec10141748683840eef1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "975a009d2854cdd961491c4043b3a46290e7a336a301bef940fbcfad8c6dd14f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37b6f1e4c8291331a9496d493278edd1721a5cdc2919f765e5ff40ae3025b329"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ec91a5d740423514e6a4e0bde2e68ff70cccecdf07701da43edbe078ba7b022"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39d0a2cad637f4eff061b84ccdd7e3fc70827e29be8abd83f7c3f2ae202f89a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c54ab40750cdaec9ef7f02cc2053b8cfad9775f0c924668686803171f8ef567"
  end

  depends_on "rust" => :build
  depends_on "wasm-tools" => :test

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
