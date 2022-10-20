class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.52.0.tar.gz"
  sha256 "3f5a44438101123e3a6535697cf13e9888869f8aeaa246ce736654127877f648"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8523fd0bcd2a5ac75a3f2a67db2fe847b7b3f18364ccdc6f9bafbfabd1badd98"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eab5658bc8972bfdfea8940e4be45507490fe7096c0dbf4b822f1c631932277c"
    sha256 cellar: :any_skip_relocation, monterey:       "ec2ffc23010b9e8682c65d00e3641a77dd6d1ecef189426cb300be7c118e36c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f231ee2d5d7c05a1d523db31c2b548cbb7f9561a1a524773133434261d1cf09"
    sha256 cellar: :any_skip_relocation, catalina:       "8dc70683fae5a1859ce356abd653d316e7e2eec00ef19b1fee4273e2285da453"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a20cde4d88afea5d1f1895e58b539bd1cf57da8d15cbbda553cf3a9574a21fb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/flarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid request headers (6003)", shell_output("#{bin}/flarectl u i", 1)
  end
end
