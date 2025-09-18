class CodeMinimap < Formula
  desc "High performance code minimap generator"
  homepage "https://github.com/wfxr/code-minimap"
  url "https://github.com/wfxr/code-minimap/archive/refs/tags/v0.6.8.tar.gz"
  sha256 "c68d4387bd0b86684a1b7c643d6281b79e018da318657254f2502ad032d52355"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97083f16317681dbf3befcdddd9ed9810fc25c2d9296f372b7b05387d3570342"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3716b4399f2bf71a5152c87ec0c92b3c5303294219d8da389df76a13d9717276"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd478a065e694fc8adb510435dc95b6d208687e21c8dc0a5c62fad2649ec1e9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "85d8ed4137ca95bc5f7460e53888d5ada7def591e478d05341d0fd8cc0474a25"
    sha256 cellar: :any_skip_relocation, sonoma:        "83ddd0a6939195e5989578e2040ea16117c4dfbbb71be9112f7e0afac7496280"
    sha256 cellar: :any_skip_relocation, ventura:       "d8195bd613d46d3ed7941deb5a442b3db073a7a663796ad24d4cde971ece9f6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9eff4702e7834b9189408f5427607ec63a01517e9d977e81fe66b202fe039fa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15fc2163649169a8c43ac0fafa401259eee14214593ec73cbf82911631d443eb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/bash/code-minimap.bash" => "code-minimap"
    fish_completion.install "completions/fish/code-minimap.fish"
    zsh_completion.install  "completions/zsh/_code-minimap"
  end

  test do
    (testpath/"test.txt").write("hello world")
    assert_equal "⠉⠉⠉⠉⠉⠁\n", shell_output("#{bin}/code-minimap #{testpath}/test.txt")
  end
end
