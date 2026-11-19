class OsctrlMcp < Formula
  desc "Fast and efficient osquery management"
  homepage "https://docs.osctrl.net/components/osctrl-mcp/"
  url "https://github.com/jmpsec/osctrl/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "4b10ac68bf33c6bd8239485871a46517ba8c26362a605f836c1619deeeb814a8"
  license "MIT"
  head "https://github.com/jmpsec/osctrl.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "efdea31ee8b3aa4cc45ca6e125b991486b9da4d17817fbf741fc37a6f59199ee"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a11d403df92f70d109183f77a6a8186f316a2ea325de4957e2af53a2ea908cd1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5c92daed58859f8bf52649845749f71ef64ebf91225d9e3689c33fce87fa361c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "120f7cc53bd80172aee1364fdd119b650330fba76bded7b4b2e1ad3a8f5f92a2"
    sha256 cellar: :any,                 x86_64_linux:      "83b6359db884deeec6036449d8e2d808fd43887690eb721e0b96feb95d831c08"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    commit = build.head? ? Utils.git_head : Utils::Git.get_tar_commit_id(cached_download)
    ldflags = %W[
      -X main.buildVersion=#{version}
      -X main.buildCommit=#{commit}
      -X main.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/mcp"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osctrl-mcp --version")

    output = shell_output("#{bin}/osctrl-mcp --api-url aaa 2>&1", 1)
    assert_match "no API token", output
  end
end
