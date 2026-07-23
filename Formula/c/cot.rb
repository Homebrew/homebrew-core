class Cot < Formula
  desc "Rust web framework for lazy developers"
  homepage "https://cot.rs"
  url "https://github.com/cot-rs/cot/archive/refs/tags/cot-v0.7.0.tar.gz"
  sha256 "8d84e6645e05b213c64e21de4e21200e04cbdcdf934d7b8aa40fa885a1ee74ef"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cdc99de1d94b70b9a00405d722258bcad5ac71f0531c1e1f08072feffcb9ed95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5dd21744f8789e94970ab3e27c61135377c98f1d5851d214534e5f382dd2c857"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01ee1546f0f7b16c04bc65846b8cd2a7e4facfae6a0c960e1b2672b325685acb"
    sha256 cellar: :any_skip_relocation, sonoma:        "e949b3b6b04118ad65abef7f6ceaca62071b6892765dbf81590ec6ab22f9c99c"
    sha256 cellar: :any,                 arm64_linux:   "ed493f2a9f1890becef960f4a8c1f5dbcbbb4fb93596147006c95c14c5e76c34"
    sha256 cellar: :any,                 x86_64_linux:  "1350a73734e01a1ba85fd36f8de7ad908cf48c5a5ee570e4bf34bd682fe0657f"
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
