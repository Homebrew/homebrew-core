class CodeMinimap < Formula
  desc "High performance code minimap generator"
  homepage "https://github.com/wfxr/code-minimap"
  url "https://github.com/wfxr/code-minimap/archive/v0.6.3.tar.gz"
  sha256 "b8237d362bfd4c9dc3c8067c97b602b7a13922510c9eaa99c8739d458a34b349"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "575444d0543a3649bc044d8844741306ea577084416cea7b7a59504a87638d49"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fff0c3c87bf02fdf0a84a5d8d4c77a8e6c1539175b9223e9a979bbdefc3551e6"
    sha256 cellar: :any_skip_relocation, monterey:       "6363e6cbcb3c4ecc6ef29526c4061acc01d38f0546e36445f09f4055d584a3ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "e898beac4a5632e3ba914ee4950b174209538c5e094487043a4c7ae1102c3e0f"
    sha256 cellar: :any_skip_relocation, catalina:       "c7141e7a80844c37358e76585dff3f3f642d92b0d0816cf5e0006065134b9ddc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3eabc89d3f15faa21c3a9c22486b1dd33fdee6b7ca28b2bdaa78a4e72e3510c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/bash/code-minimap.bash"
    fish_completion.install "completions/fish/code-minimap.fish"
    zsh_completion.install  "completions/zsh/_code-minimap"
  end

  test do
    (testpath/"test.txt").write("hello world")
    assert_equal "⠉⠉⠉⠉⠉⠁\n", shell_output("#{bin}/code-minimap #{testpath}/test.txt")
  end
end
