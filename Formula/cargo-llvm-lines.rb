class CargoLlvmLines < Formula
  desc "Count lines of LLVM IR per generic function"
  homepage "https://github.com/dtolnay/cargo-llvm-lines"
  url "https://github.com/dtolnay/cargo-llvm-lines/archive/0.4.26.tar.gz"
  sha256 "73eb46862751591196a4c611ba0bb668442c8dd659bcb05b1ed45859ef7b8a21"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-llvm-lines.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "687d0e26ee29ce1cf8d93168d7aea6a59435e6526a7a2030d28c12d58350e62e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1692c5d9faa28665040462e9d8340233304a91149e48648080d6907c9a551171"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49f7dfcecba8a9247f4ded24658b3c339909892a3723d5d0df875e4a818eb99e"
    sha256 cellar: :any_skip_relocation, ventura:        "46b65754bb4dc8012029e0880f09b35679afb65a75be29f3f4358919eb3f1ff1"
    sha256 cellar: :any_skip_relocation, monterey:       "02d6f333f43ad2b093532aa1fdf89bb6a0a5f0304b62175080b8a7ed46bb7d1e"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0d2f447b4719d474d86d5e43dc08100257de3e18a83228c0169f2040f7ee1c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8178f858a99a47da3af898701b498c603b04cfd19c2449fc3ba5e8eef61f6125"
  end

  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      output = shell_output("cargo llvm-lines 2>&1")
      assert_match "core::ops::function::FnOnce::call_once", output
    end
  end
end
