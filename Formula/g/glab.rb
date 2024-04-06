class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.38.0/cli-v1.38.0.tar.gz"
  sha256 "e41f7c04d782936562f7eee6866ae973aa4f2807ade643372a918d5271f279c7"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3cd4660d23a5b9593df963499a8468b7c5cd4c766c09cc24a791c2916cc356eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35c78493a5381a4f172cd87113b3f310cbce557177262290be0bc683e7e7bf98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "921daa9c4fd0a51b0705180ce0128d076714421bffa85e092c540440d271744f"
    sha256 cellar: :any_skip_relocation, sonoma:         "28688556c949eb1015dd16a764110ffa5d10d186372d97454de2b85418be3894"
    sha256 cellar: :any_skip_relocation, ventura:        "e53dd409add123e8f97309b744023c3c778ffa8798347a4899faf0dfb891b2db"
    sha256 cellar: :any_skip_relocation, monterey:       "6fd000e623354d52b81aca807673a5b893ca3ad23c17ccd70dfe4c9696e0d64a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3307560456b13d284b0d2a6610799504b29743a528a2526924eec1fbf5c5d73d"
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
