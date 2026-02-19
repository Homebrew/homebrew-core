class Cot < Formula
  desc "Rust web framework for lazy developers"
  homepage "https://cot.rs"
  url "https://github.com/cot-rs/cot/archive/refs/tags/cot-v0.5.0.tar.gz"
  sha256 "cc0ecb18c0936faa6b45132b1f26165c78e5dc026385be5ffbf6583a37d410b3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f49168ef7185f9913abec4529a3989942be8228f682d077d12ba56b2ae7cec1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "143d6ead2384a0304331c46aae4969e9b25f2d5427bfb10c2b00f39129b0685d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48c8ad7a25c636a2faa1b9942be723f81b6a39e84731b01e803a71b3652cce5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b62e01680e2916a7a93190fa70fb4bff1daa1a47dfd79af54bfe17fcc9f6c1e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6908f2349a3ed8cfa0eb06fd2eb08d72441acd76fa6a05f7c0bd39beb1e469ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3eccbd8666727dbb6f0cf095d53e3369f907fd616b0a78b8139be4b8e2052033"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cot-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cot --version")

    system bin/"cot", "new", "test-project"
    assert_path_exists testpath/"test-project/Cargo.toml"
  end
end
