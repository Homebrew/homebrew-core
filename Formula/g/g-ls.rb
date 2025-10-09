class GLs < Formula
  desc "Powerful and cross-platform ls"
  homepage "https://g.equationzhao.space"
  url "https://github.com/Equationzhao/g/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "122ca7ebf32ab2aada05cd513d44b55082d9bcfa9b890ee0ff60fdebfea06d0c"
  license "MIT"
  head "https://github.com/Equationzhao/g.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d62e75fef5133acb354d578e93f981f47c4dafb61c496be3597d2c87302950e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb3191fbc85fbd24fb30ccba9d6ffb3e6d77dd990a4a4cab6e2221c661ef8fcb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cf59fb8cf8298b9a6b0f6ec56f0d3bdb68347901761848140409cf487debb9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fc5f4556c356118abc88b66ed21a4ad35565328d422464fc20cac30b29f434b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b203477a74e2996df047e202b4f8827d68c98d1db639a6bc9ff33fac6938d6a"
    sha256 cellar: :any_skip_relocation, ventura:       "81225e99df84abf8e659e76c2b48eb4e46f4ce841d1809c66db0b828a9050a0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dad7f157a9be7a8c16b23b585f24ded385df6d308e3e63ab233f7b965abeae9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8fbf36aa3e158d614b9a5dfbfcc8598bcbd7b2f79e516a1bec447281a790495"
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
