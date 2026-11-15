class Oauth2l < Formula
  desc "Simple CLI for interacting with Google oauth tokens"
  homepage "https://github.com/google/oauth2l"
  url "https://github.com/google/oauth2l/archive/refs/tags/v1.3.6.tar.gz"
  sha256 "5e09371bc245946cadecd3c73de7b782c1f933816678f7f5dff0d5632da5ae0a"
  license "Apache-2.0"
  head "https://github.com/google/oauth2l.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6c61591ae14f4782c3056235af85119ecaf92cb044fcfeb56406222b0680f9b9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6c61591ae14f4782c3056235af85119ecaf92cb044fcfeb56406222b0680f9b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6c61591ae14f4782c3056235af85119ecaf92cb044fcfeb56406222b0680f9b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0389f1000fe2739e2e265b2c195dc1a25823a4b93ae4416dc46502de40ff474a"
    sha256 cellar: :any,                 x86_64_linux:      "6d0f185f5202808bc62e620c388020124bd88a7c531910aa4984fa931f340b2a"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match "Invalid Value", shell_output("#{bin}/oauth2l info abcd1234")
  end
end
