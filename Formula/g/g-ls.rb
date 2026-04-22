class GLs < Formula
  desc "Powerful and cross-platform ls"
  homepage "https://equationzhao.github.io/g/"
  url "https://github.com/Equationzhao/g/archive/refs/tags/v0.31.2.tar.gz"
  sha256 "a1ef8a6872fa80625287c19167152081b833abc4db88910ab145b35b3bbc6da3"
  license "MIT"
  head "https://github.com/Equationzhao/g.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c10dd7d5f17f3f28774bce6f3337fea1448c43c69ce13a2348bc703ba5358d2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "410ebe35920decbb9a8d33a277e5bba7cf0c539768a84522d035f0983d4a6bf2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25a7a46ea6ea08bf6bd69a85dfa3ebe6e6193e87e95ee2eb02c113fe1e7f81ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5ae88093499d0e6581b7db2078cc73fdb34e5aee1cc2420b49bf5098b6564c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aeb4dbf3c8c017ccfcd4ec77abc39842329e2e793f1bc0a1bb976d7a1e490389"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67cfa779494f020ecbc18a8342b430829d8b53b3ff31696402e6efa41d4c3d07"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"g", ldflags: "-s -w")

    bash_completion.install "completions/bash/g-completion.bash" => "g"
    fish_completion.install "completions/fish/g.fish"
    zsh_completion.install "completions/zsh/_g"
    man1.install buildpath.glob("man/*.1.gz")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/g -v")
    touch "test.txt"
    assert_match "test.txt", shell_output("#{bin}/g --no-config --hyperlink=never --color=never --no-icon .")
  end
end
