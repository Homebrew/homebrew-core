class CodeMinimap < Formula
  desc "High performance code minimap generator"
  homepage "https://github.com/wfxr/code-minimap"
  url "https://github.com/wfxr/code-minimap/archive/v0.6.0.tar.gz"
  sha256 "6f67ed03b33863186c4811b1c8acc6b0cc9c6c63f2bd5b54dbf703f7fc561711"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f798db57c9bec0e39bc8f7f30f8445e3df53032d1686ec2549e37218873d2f5e"
    sha256 cellar: :any_skip_relocation, big_sur:       "34a54ec8b3e68ada2fe286dc61f7626de51b1ee29360be034566f34bc468a24e"
    sha256 cellar: :any_skip_relocation, catalina:      "27b9629e0fb3cdc4e2629ae150ffc13ce8cb6c5448f02f888395d53219b2ec59"
    sha256 cellar: :any_skip_relocation, mojave:        "490595ba892b4bfd1170af45ca829af08015a371f0eedb7e41d7b9db51c9e8a4"
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
