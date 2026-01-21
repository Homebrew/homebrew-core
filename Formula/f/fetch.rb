class Fetch < Formula
  desc "Download assets from a commit, branch, or tag of GitHub repositories"
  homepage "https://www.gruntwork.io/"
  url "https://github.com/gruntwork-io/fetch/archive/refs/tags/v0.4.8.tar.gz"
  sha256 "8192dddb375e2a8765e54e27c65b544068b35bd349f9ad669d6269734f3b5f76"
  license "MIT"
  head "https://github.com/gruntwork-io/fetch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16084f167de5082df4b3ce7198fcf44672bd2039929c2e61e2a1118710e3debc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16084f167de5082df4b3ce7198fcf44672bd2039929c2e61e2a1118710e3debc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16084f167de5082df4b3ce7198fcf44672bd2039929c2e61e2a1118710e3debc"
    sha256 cellar: :any_skip_relocation, sonoma:        "06a16319c84b85d5e26f0586a344f9f95572ff3afff275ff494846e98794ed5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "930d8ca1b12f0cc94cce20a1b637ffb956499bc0f515882fb4780c5e3892bf88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10b5de8d86085f6b4b75c5dc54e38301f452adfc9de38b49d0cb907acb8929bb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fetch --version")

    repo_url = "https://github.com/gruntwork-io/fetch"

    assert_match "Downloading asset SHA256SUMS to SHA256SUMS",
      shell_output("#{bin}/fetch --repo=\"#{repo_url}\" --tag=\"v0.4.6\" --release-asset=\"SHA256SUMS\" . 2>&1")
  end
end
