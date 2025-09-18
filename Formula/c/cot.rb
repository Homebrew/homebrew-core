class Cot < Formula
  desc "Rust web framework for lazy developers"
  homepage "https://cot.rs"
  url "https://github.com/cot-rs/cot/archive/refs/tags/cot-v0.4.0.tar.gz"
  sha256 "590ada9692fb28426f94280c1642bf2aa6c36fdc2c940ac71bc33011c4969b8d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8ffcfb65d79e650fad48210f0e4047194bf48f7ac0e39fcd01f2bbb172de4b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0918e6397771642e1d6b4c341e70172239d0e47f66bab6b4492c3ee5bcd2a339"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7becb7d2b615af5fdfbd8315ad84c7b1f5e3d0f6b1400d0b3e0e85a218d59fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a15ca90aa6c119e9d9cffb663514908d9d1ae708af9879379a34fad5d47a198"
    sha256 cellar: :any_skip_relocation, sonoma:        "a170f45a7999ec42ee9986877a0d75066b4d16f047ef2736fb2a4c48d14320e3"
    sha256 cellar: :any_skip_relocation, ventura:       "3179696b655c6e8e09d70d497e9efe8672ada1b9e243f55845904e7d0de9fe07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c716a0e45b1a9eb0c66a3289bd62a724184e60685608df828620c69e70b512a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c61947e23edbe24f383949d80128c5e537c2641bf07a1409aec859bfc316091"
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
