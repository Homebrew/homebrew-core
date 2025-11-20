class Hoverfly < Formula
  desc "API simulations for development and testing"
  homepage "https://hoverfly.io/"
  url "https://github.com/SpectoLabs/hoverfly/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "7e4dedc9e951516b25e257ee0d7bd27984c43fa3529cb4c322e1615bf01ba15c"
  license "Apache-2.0"
  head "https://github.com/SpectoLabs/hoverfly.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77f2a84234d7436b65182abe3b95208f43d1df4f54fd19a3b587e7ebcaadbf32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77f2a84234d7436b65182abe3b95208f43d1df4f54fd19a3b587e7ebcaadbf32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77f2a84234d7436b65182abe3b95208f43d1df4f54fd19a3b587e7ebcaadbf32"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cd6498da452e723f2f00d2be33993ed42f4ba8f7cb0cd5d59e1cf30aed1b458"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31c34150aa57c94bac3aa1bdcd11e5ac40c22259b42d138a588534a59a438e50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2413ac764f340308ba77a482b8f793a6e27440cbb21983f91e7de88cd3eb742d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.hoverctlVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./core/cmd/hoverfly"
  end

  test do
    require "pty"

    stdout, = PTY.spawn("#{bin}/hoverfly -webserver")
    assert_match "Using memory backend", stdout.readline

    assert_match version.to_s, shell_output("#{bin}/hoverfly -version")
  end
end
