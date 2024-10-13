class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.io/"
  url "https://github.com/konstructio/kubefirst/archive/refs/tags/v2.6.1.tar.gz"
  sha256 "f7337e9772e529ae53aa1e2c3343f455a167c4f8478b91e8ae1c11a375b8ea80"
  license "MIT"
  head "https://github.com/konstructio/kubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "cc228ca3c80971b79e9a65237119f95a108b4ea4c0eabaf268589a9ad00359b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d49204aecfabf77ddd45a79308652645607b163e70dd0356dbfaa6017ed0c589"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a244fad1fed8b5591a0af8c0e85f22fba883e86738b52361aad7e6f9ba134aba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68b6350842bcfc0e3fb5b1aa9ce9be3d81cdb5a82c4e5b51ac5545b917923974"
    sha256 cellar: :any_skip_relocation, sonoma:         "edb28db20f6ad0fca0f2deb2bc4d8d3bd470e4c73f2556700a0696c36c8fc811"
    sha256 cellar: :any_skip_relocation, ventura:        "2b6de82f8f9cebc0f1d57ef8554ca33df91763c5f8106546e30328a7d06962f4"
    sha256 cellar: :any_skip_relocation, monterey:       "81148eb33417d6379573baddcc743d993f6a6a7945fbbacbb1b6ff3ae7beeee7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21762a02134c7af0ded267fce260d909b127dd8c0a0745c5c5a814fe24bc07c9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/konstructio/kubefirst-api/configs.K1Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    system bin/"kubefirst", "info"
    assert_match "k1-paths:", (testpath/".kubefirst").read
    assert_predicate testpath/".k1/logs", :exist?

    output = shell_output("#{bin}/kubefirst version")
    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      ""
    else
      version.to_s
    end
    assert_match expected, output
  end
end
