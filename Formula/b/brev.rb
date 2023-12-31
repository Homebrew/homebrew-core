class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.267.tar.gz"
  sha256 "e64cbbab24fc218f20de05a079a61795b55cc62d8d766020c9304428bbb48d18"
  license "MIT"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2a138ed2bb113111091e4b97494bde9e63f6c2af13b066fdb47c4d18c7fc45f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6cf4f731ddb6f5f350bd1fe25aeb8ad42974abfc234595c96f56d2bba9a1bee1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3042d6b4298b830010c169e2de1caaa14663c3ce4452e2b97fb5dc3cad90b619"
    sha256 cellar: :any_skip_relocation, sonoma:         "f5890f4eb0cdacfa28c81db3206e4db54d58ad66742274795103eec2bf1f96c7"
    sha256 cellar: :any_skip_relocation, ventura:        "0c5607ce99c9ff80d9078d958da8ea99af15d4ba2e706cdf91de566952d5b808"
    sha256 cellar: :any_skip_relocation, monterey:       "348fa5a37293eed47d462ba17b86606d0c77fb721a8d65adc58261ef87494a10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f16a0426f522f0a33275d8302b3c9831f3c9335154589b07c22a2e0490ea064"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
