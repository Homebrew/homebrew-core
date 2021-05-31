class CodeMinimap < Formula
  desc "High performance code minimap generator"
  homepage "https://github.com/wfxr/code-minimap"
  url "https://github.com/wfxr/code-minimap/archive/v0.6.0.tar.gz"
  sha256 "6f67ed03b33863186c4811b1c8acc6b0cc9c6c63f2bd5b54dbf703f7fc561711"
  license any_of: ["Apache-2.0", "MIT"]

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
