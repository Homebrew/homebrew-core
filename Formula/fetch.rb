class Fetch < Formula
  desc "Download assets from a commit, branch, or tag of GitHub repositories"
  homepage "https://www.gruntwork.io/"
  url "https://github.com/gruntwork-io/fetch/archive/v0.4.4.tar.gz"
  sha256 "5e5af89111a2e986d7d59c156c55ca301c9f2199369c9dc89b80dc94cb62b31a"
  license "MIT"
  head "https://github.com/gruntwork-io/fetch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "837779f78d0700888b4f42cd0c3ae77bfb4365dcc1ffc4480082375b3de4750f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f1a5814ad2577387d356b1a10bf897b3ec2185b5b9de9a44fdbcd11f9116258"
    sha256 cellar: :any_skip_relocation, monterey:       "0d5dba201cabff02a8da2779a805ef4552ef54098b4eab86b110085c7d81c8b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "da985a806b15f92791d6df43b5e541df94e2fb9f6a0238a8fe3b4ae6064a52ac"
    sha256 cellar: :any_skip_relocation, catalina:       "85ce4f6c485a19995f8e4ed2f80a7bd898b31bc28a734175268d3087fc4457d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c415e6fb8720c825034807d77167f4ddcd382ab9c1374d912ba46398b4f41643"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.VERSION=v#{version}")
  end

  test do
    repo_url = "https://github.com/gruntwork-io/fetch"

    assert_match "Downloading release asset SHA256SUMS to SHA256SUMS",
      shell_output("#{bin}/fetch --repo=\"#{repo_url}\" --tag=\"v0.3.10\" --release-asset=\"SHA256SUMS\" . 2>&1")
  end
end
