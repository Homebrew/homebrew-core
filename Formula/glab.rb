class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.25.0/cli-v1.25.0.tar.gz"
  sha256 "7c3b86e94962ca6aa380eccd95fdc9443e9c41aa941a6cd8e2f11f44bf38d7f7"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5699dda9cbeeac90decb14a33bc59627c430fbe26cf9ec141f856c4de5e3090a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a9f222fbdcb8f1fca24aab20f51464084ba3148201f35a1fc85beec8f9590c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "593890e7997cf8e310c9a58ee8bc8ab20cbbee1ab6d203f1cebe969273a256f4"
    sha256 cellar: :any_skip_relocation, ventura:        "c8b1c3dc337dd5a637fd40636bd7c69268a008ad1c559efab60d0cfaa77574fb"
    sha256 cellar: :any_skip_relocation, monterey:       "69dcd7c496d799e0ce50eeadeef624b2a962e82327d54f67d9d45be97a911161"
    sha256 cellar: :any_skip_relocation, big_sur:        "76be8817d090679e93a7b182564589b04bd2a0d5150b9b2ab93eb7f9826f6181"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44d6143b5459492abb9e80301244724f3b026d6cc6286a0b31f9538e8c4ec803"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?

    system "make", "GLAB_VERSION=#{version}"
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
