class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.116.0",
    revision: "e8436ca8a1715369087a8c67787493b2434a3822"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18ea03283cd18270bb61bd50003945252767cbf4746db153736f9e0016f6de17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18ea03283cd18270bb61bd50003945252767cbf4746db153736f9e0016f6de17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18ea03283cd18270bb61bd50003945252767cbf4746db153736f9e0016f6de17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e197e77de73231826256ffc4d7aadb98d486e0837840812b46dee4f7d54dc82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6a9c0160408d010296c6623e03ecbfe21ee31215b4046a4123c7a81c52a3fec"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?
    system "make"
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
