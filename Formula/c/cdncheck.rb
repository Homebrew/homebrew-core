class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "4bc726abe474033408f01b0f5cc488de1b3211836a5bec9446c6fa8a431d72c0"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4d9c6ffa1f4f3953da5688f2b5d09a1cdaade70ce3be341c38e11aa9dfb50206"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f8c78630dcdbb1c01f1ebd033afd3751dfd28239130548c0833d29c1c3b6a66c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "286fb6dc33a56c46e42df37a784c430e0c2a988160c320c1c524d26b94bdf436"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ea229a94339383624dbdd22fcedda651171341cea590bc7e71dc9345d6e2d331"
    sha256 cellar: :any,                 x86_64_linux:      "fff9402742ef2c860e24188b00f7164a8f20214c888c0e9644e90f79e6e1aced"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "cdncheck", shell_output("#{bin}/cdncheck -i 1.1.1.1 2>&1")
  end
end
