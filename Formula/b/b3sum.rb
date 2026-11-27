class B3sum < Formula
  desc "Command-line implementation of the BLAKE3 cryptographic hash function"
  homepage "https://github.com/BLAKE3-team/BLAKE3"
  url "https://github.com/BLAKE3-team/BLAKE3/archive/refs/tags/1.8.8.tar.gz"
  sha256 "a5b927e875e16ebe76bacc1961107d2135637aab39ef227006fea27634e94cfe"
  license any_of: [
    "CC0-1.0",
    "Apache-2.0",
    "Apache-2.0" => { with: "LLVM-exception" },
  ]

  bottle do
    manifest_sha256 "02f7c224e8e0d23414fe68d828bf8380ca25f8aafffb5e7a1bc8b92500cda890"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6528f042a8498b792021146100601054e7b384804c1ef31ca3bee40f24326575"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ad5445efc1666446998196f0a34e6e40e65a7c122f2e1dbf02074aaa3029bf36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "aad2fc3f3afa33c63594f1c9f1d9cca956ddf957d72a8f0cc5b40717e3dfec70"
    sha256 cellar: :any,                 arm64_linux:       "0e33e19ed1cb35f382a706e22b3ffd934af117a523f821132f1503c231cc65d3"
    sha256 cellar: :any,                 x86_64_linux:      "e55d02573c5dc38da5d86a06aadd3d93dc1307dd8fd4f5ec25e5f7aa1a106db4"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    cd "b3sum" do
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

  def install
    cd "b3sum" do
      system "cargo", "install", *std_cargo_args
      buildpath.install "README.md"
    end
  end

  test do
    output = pipe_output(bin/"b3sum", "content\n", 0)
    assert_equal "df0c40684c6bda3958244ee330300fdcbc5a37fb7ae06fe886b786bc474be87e  -", output.strip
  end
end
