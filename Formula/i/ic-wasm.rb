class IcWasm < Formula
  desc "CLI tool for performing Wasm transformations specific to ICP canisters"
  homepage "https://github.com/dfinity/ic-wasm"
  url "https://github.com/dfinity/ic-wasm/archive/refs/tags/0.10.0.tar.gz"
  sha256 "1c4b6c6f0235a3baecb7d568bbf3651c4a89cf9a376d746735e507ce0bdaa439"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "829bfa55e72350bb28c4cff4cf5c50fd3150d50dc2e7b6251da6f81ad51942ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ef1f6d5c0d9047fa33e37b1be866ea8ffa585fdf5592d91f3a2b76254b157e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a434ff4b7a9144ca0f55fbbf8bd4dc25e178ec79061eebc193a9410748f7f2c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4bf099d8b631697ae9b967f9e023fb0af73f918347893aef8410baf4db5a77fa"
    sha256 cellar: :any,                 arm64_linux:   "3a0eabb303d8f5f46e0de59df26c3c420a653dfd0bc7c197cb318d292d1baa3b"
    sha256 cellar: :any,                 x86_64_linux:  "44a92fab5a3672c8a8f8389158b723b2176328662c504ed0dddcc5a14d9cd672"
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
