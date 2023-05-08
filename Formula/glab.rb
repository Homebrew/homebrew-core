class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.29.1/cli-v1.29.1.tar.gz"
  sha256 "780bd9cd8c5dac9848bde5210faf6384cf752116853de23cefb6dcfa75e4dc5d"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b64c553f56daabc21e12d405fd67d48b916da148a5ddf8ab1f1fc8554cb9998"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b64c553f56daabc21e12d405fd67d48b916da148a5ddf8ab1f1fc8554cb9998"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b64c553f56daabc21e12d405fd67d48b916da148a5ddf8ab1f1fc8554cb9998"
    sha256 cellar: :any_skip_relocation, ventura:        "d64bf3c0c2f32423b749e6e13976d038bb486a76ca45d93cdede9689371432c1"
    sha256 cellar: :any_skip_relocation, monterey:       "d64bf3c0c2f32423b749e6e13976d038bb486a76ca45d93cdede9689371432c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "d64bf3c0c2f32423b749e6e13976d038bb486a76ca45d93cdede9689371432c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9ecd3d1f896256e1fd0a5a64f55d754734c026f96bd864484c430227007f15e"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?

    system "make", "GLAB_VERSION=v#{version}"
    bin.install "bin/glab"
    generate_completions_from_executable(bin/"glab", "completion", "--shell")
  end

  test do
    system "git", "clone", "https://gitlab.com/cli-automated-testing/homebrew-testing.git"
    cd "homebrew-testing" do
      assert_match "Matt Nohr", shell_output("#{bin}/glab repo contributors")
      assert_match "This is a test issue", shell_output("#{bin}/glab issue list --all")
    end
  end
end
