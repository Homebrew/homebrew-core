class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://glab.readthedocs.io/"
  url "https://github.com/profclems/glab/archive/v1.22.0.tar.gz"
  sha256 "4b700d46cf9ee8fe6268e7654326053f4366aa3e072b5c3f3d243930a6e89edc"
  license "MIT"
  head "https://github.com/profclems/glab.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58a6efde41f754f75de93a2c6ddc50b888237f5a6d268cc22c375722972537a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4fb720719b0cd88b52688b7298ef5b07b510d0eb0fd2b3067a7f3fe47303dc9c"
    sha256 cellar: :any_skip_relocation, monterey:       "335d3798ad846544e68dfab75abdaedaf40397db17e5de76c9a5462c231285a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b384f05896c4cc28fc9e679549825792320c54bdf675293dffffb1a6c2717d1"
    sha256 cellar: :any_skip_relocation, catalina:       "92114845aab1c15d5f52c0591d44508c28a4349a46e0f7669d5d551806155759"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e105a8bb9694c9fd2569785a576265bf732c6a19ff8f1c42a430e8783b36d69"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?

    system "make", "GLAB_VERSION=#{version}"
    bin.install "bin/glab"
    (bash_completion/"glab").write Utils.safe_popen_read(bin/"glab", "completion", "--shell=bash")
    (zsh_completion/"_glab").write Utils.safe_popen_read(bin/"glab", "completion", "--shell=zsh")
    (fish_completion/"glab.fish").write Utils.safe_popen_read(bin/"glab", "completion", "--shell=fish")
  end

  test do
    system "git", "clone", "https://gitlab.com/profclems/test.git"
    cd "test" do
      assert_match "Clement Sam", shell_output("#{bin}/glab repo contributors")
      assert_match "This is a test issue", shell_output("#{bin}/glab issue list --all")
    end
  end
end
