class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.40.0/cli-v1.40.0.tar.gz"
  sha256 "0e426a4b0b1945fa16b504c2245a9a525e0b4a858565e482d934b481163d87b5"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "859fea29ce43bcbad64b429356ce16890a28d8764ee1cbee2bddc54ea5589662"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32068d2b89d8042fd871ab5421044eea3bc00c1130fb91ba4f3deb3865c3feaa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f18b230271411dad08a36975578cd2de6fbe900c63faeccf8eb1116e4d5e28a"
    sha256 cellar: :any_skip_relocation, sonoma:         "32541b5965aa82cb08b7b5219b6aea264b47675de0a25993b03b8261101aa150"
    sha256 cellar: :any_skip_relocation, ventura:        "c0a7fd226e95ea4e2bc6d89b10c73584a0de6d48c9f35048c31779ede16869ad"
    sha256 cellar: :any_skip_relocation, monterey:       "901388bcd9c49011886aa6bb5c5cec37255af5f4da2f43f276f4a4baefb538e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6004098975b0a2d76a03b6564df08fa0042f70039d4da6bfe3675aef62946888"
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
