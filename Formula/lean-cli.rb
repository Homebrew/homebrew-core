class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps"
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v1.0.1.tar.gz"
  sha256 "d1cd31c4942a1d321ce6c608973f32f513df892b1441930169bc825149f77e98"
  license "Apache-2.0"
  head "https://github.com/leancloud/lean-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15fb26ba22cb952223109e0972df9922fe0eca21ea86e2fc4804515e26201670"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "420a19e7e6b42501fbfaf65a5400e585dc6de4da0b02bba76ec49f9e2a0fde26"
    sha256 cellar: :any_skip_relocation, monterey:       "f7b7f47312af11dece30e6608a6145f49ee613482874b87308af69e79e81356a"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e4e38188e3d42649e1954de6e6d9a9095e7649d84a09bcad17a29e4f7fcad2e"
    sha256 cellar: :any_skip_relocation, catalina:       "9067248d2f2995bebafc858563bd72dde361ebf9706ce1ac370186a4989bdddc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88893d965ff05d9a760a001cb2a47ae6009b8c9c542dfd78820cf94103695e90"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    build_from = build.head? ? "homebrew-head" : "homebrew"
    system "go", "build", *std_go_args(output: bin/"lean", ldflags: "-s -w -X main.pkgType=#{build_from}"), "./lean"

    bin.install_symlink "lean" => "tds"

    bash_completion.install "misc/lean-bash-completion" => "lean"
    zsh_completion.install "misc/lean-zsh-completion" => "_lean"
  end

  test do
    assert_match "lean version #{version}", shell_output("#{bin}/lean --version")
    assert_match "Invalid access token.", shell_output("#{bin}/lean login --region us-w1 --token foobar 2>&1", 1)
  end
end
