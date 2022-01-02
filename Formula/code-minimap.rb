class CodeMinimap < Formula
  desc "High performance code minimap generator"
  homepage "https://github.com/wfxr/code-minimap"
  url "https://github.com/wfxr/code-minimap/archive/v0.6.4.tar.gz"
  sha256 "4e2f15e4a0f7bd31e33f1c423e3120318e13de1b6800ba673037e38498b3a423"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf64df506d3d8c88b5b792b44cd20785c0f89e067a8ea0bdb504313cdc6a93cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49047a027d756af8a37fea02c4e79fc8ca6017e420e2393dd7e9b7571e7000f5"
    sha256 cellar: :any_skip_relocation, monterey:       "d3b17f32cbdc0305b1efebb366bef182d76444442fa7830b8d2ce596dbaafe3b"
    sha256 cellar: :any_skip_relocation, big_sur:        "7fb51c7905b9763fa5e3bf7092e79b63d0735a5b00728ee6b3563c8e01b51f21"
    sha256 cellar: :any_skip_relocation, catalina:       "8af0b53c06c10b278d1a0fe8e5ad1cdf72d606eaa0afe592a7616f77ca4c5cff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "593b2d08845099ec900b2c40d970ff8b3fb7495d6265c443d1dfa18d4c37682b"
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
