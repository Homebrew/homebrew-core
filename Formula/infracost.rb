class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.10.0.tar.gz"
  sha256 "fd73871e4f3023aa686788844280580aa49db38d949beb4499a7e364efd6cbf9"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab1f6fa8c2e0beea0c89d0748bdea21d095ca40ce81bcf9e42b7271cfe3641ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f699f689edcfe5b2a44f0e5dc5cee9da1a63aa6c070f9a3da70ea9a07c0326cc"
    sha256 cellar: :any_skip_relocation, monterey:       "61cb4112067c5b72573acfe12af96e1127fb2a279fb882216f7c58a4d4b1c631"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d1d3974aeac011c7202113f6b1b51679dea5fc40bc99856f9fe8baf303ba71a"
    sha256 cellar: :any_skip_relocation, catalina:       "50fecf19f222c4d56764b5c029e30eebc008c2dfa9a5c93aa001e1b1e3e6b2b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f83570ebbffadcaeddfbf4bbecb493d8667b6abca8460d59a394fea658126454"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/infracost"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    output = shell_output("#{bin}/infracost breakdown --no-color 2>&1", 1)
    assert_match "No INFRACOST_API_KEY environment variable is set.", output
  end
end
