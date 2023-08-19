class CodeMinimap < Formula
  desc "High performance code minimap generator"
  homepage "https://github.com/wfxr/code-minimap"
  url "https://github.com/wfxr/code-minimap/archive/v0.6.4.tar.gz"
  sha256 "4e2f15e4a0f7bd31e33f1c423e3120318e13de1b6800ba673037e38498b3a423"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6dd5a19c632f2f0a9f7f36116ca47aa6cb2d461bacffd5e057f6957dc6997701"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5860b64be3fd885f0f3596971a38c84a0a7aff01e805d2226dfe37d4261634a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f541ddb82e19e68bfff17a19756c3270a2ab087bd9ad7de76a524407965efb5"
    sha256 cellar: :any_skip_relocation, ventura:        "90165065861e01a7c0004a1f3e216f74309dca89fd2b467561a5335c14793918"
    sha256 cellar: :any_skip_relocation, monterey:       "b8bcde829b9158c1608fb9d43854a19a0b90333932d053e0dd11fb8f48985686"
    sha256 cellar: :any_skip_relocation, big_sur:        "8392793686aed76ac84933cbf4b2ee6b914b5d7dab315615872af14c16ae9f4d"
    sha256 cellar: :any_skip_relocation, catalina:       "10a8fe0a0ae6b70d4f82ba3931aa9a7eb7451727b18a8dda8d2065d9d58da6bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2289ca16b0c06af4d8880a69f70e610480b59bfe6c1f9352a072eca6ba6be9b3"
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
