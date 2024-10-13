class GLs < Formula
  desc "Powerful and cross-platform ls"
  homepage "https://g.equationzhao.space"
  url "https://github.com/Equationzhao/g/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "c76566378d8aca166ba33e441d9730e01838ade28f221e9256d5123c1d75e560"
  license "MIT"
  head "https://github.com/Equationzhao/g.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "bc4a6d485f6072e3184f3a3b94afa5849a3f44a1bbcdb3a3b254e7cab7c835b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b4ab4e88bf5ea2d58748f80ee923e7fa4098bd3359181024f07eacd372dce51a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6c823cd9480687caa3f4df92dc5fd8495fed9b9f7fa4e8bd0e97a6a753ad657"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d7b1e0b9b17e8b1567eeac93a8cc46ebe8094348ffc8108c1594bac6be2bf53"
    sha256 cellar: :any_skip_relocation, sonoma:         "9be4467bb38010cfe2f42c99119eabcb08e1f08649a5a0ceae389ef6bf8ba302"
    sha256 cellar: :any_skip_relocation, ventura:        "98b43c29665fe23dcda5c677e766686a51cbb1e0e86a7741fb5a7d272b9cb490"
    sha256 cellar: :any_skip_relocation, monterey:       "3d281739ac9228f5285a84dce93af1f16bff71d3aff2249d988896c15b5eef5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0362f1f6586b1588c894f64b54af22a87aae22cfac101730aa49e5c47e8278d5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"g", ldflags: "-s -w")

    man1.install buildpath.glob("man/*.1.gz")
    zsh_completion.install "completions/zsh/_g"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/g -v")
    touch "test.txt"
    assert_match "test.txt", shell_output("#{bin}/g --no-config --hyperlink=never --color=never --no-icon .")
  end
end
