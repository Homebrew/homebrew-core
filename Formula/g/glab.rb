class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.33.0/cli-v1.33.0.tar.gz"
  sha256 "447a9b76acb5377642a4975908f610a3082026c176329c7c8cfed1461d2e1570"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1328e19886c3dfde8ba4784d96fd891be8a6ce0d53bd94c65d50cc9eda9dada7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d5f5835b942c8b1d6dd330f9ba671c69ec6bd4f3bc6d5a45f11e56b8a3ff5da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da6b64ed0a702c859c2dcfb7386ae99d66ad7728ea414153ff9fccc71811719e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c73f473998cbda39a0aa7082f764afd470493a38b0502444bb0dfd7bd71bd5dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "b81333e9077b8a83813123ac15b1113eef6511df062af115042d75c736f87a84"
    sha256 cellar: :any_skip_relocation, ventura:        "d7204694723144182480237e0986d121f2787e593ff0865a7b7c41a0d37b5e35"
    sha256 cellar: :any_skip_relocation, monterey:       "dd0b04890c7d9fa9f3d96343edaf901133ce1183bdeb0ae067915ad598388dcd"
    sha256 cellar: :any_skip_relocation, big_sur:        "a90355a37cee2ae619f3c5be065f1603e1e0eeb1d82ac23c9d8e131141f7a966"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "431363afdfe7ae3086b473648dbb59cd64715c7f05ae0adaa7d8cf426441f0de"
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
