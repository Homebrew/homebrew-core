class IcWasm < Formula
  desc "CLI tool for performing Wasm transformations specific to ICP canisters"
  homepage "https://github.com/dfinity/ic-wasm"
  url "https://github.com/dfinity/ic-wasm/archive/refs/tags/0.11.1.tar.gz"
  sha256 "0ad9b97cc85a66d862f0b855860c4c2fbaa247c62fcc7b6092c18ba4ac4c5199"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00c5bd941b3aaba552b0fdf5b484f3a2b6bbfc370c327aee7e3206a9191fdfd8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db165fc477d53fd00b9dbea404845ed74d01a01193c294795290c233b887a8e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e861bf507eef93bb35114164df4a18ccaa060376e46c360e1cabd70ea613f2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f8eaae57653b8efb76e89ece8b5beb8da7fc0dc598c09372b88e7c0be11647d"
    sha256 cellar: :any,                 arm64_linux:   "7b5ac667397692b364e3d564b130b5ef9735f5322d5cf25361a737b042b795e3"
    sha256 cellar: :any,                 x86_64_linux:  "b2eadc7b51e72fdccf409b0647ba811d98290a9f77e4e95ac24423ef355ae4b1"
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
