class Cloudlist < Formula
  desc "Tool for listing assets from multiple cloud providers"
  homepage "https://github.com/projectdiscovery/cloudlist"
  url "https://github.com/projectdiscovery/cloudlist/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "53efb4bff46b533fab0bbb0003c3fddb5874e64cde8beda977856af3e8fdb064"
  license "MIT"
  head "https://github.com/projectdiscovery/cloudlist.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05ee74dbd140cf4d1fe0390ee4e72107f3d0c2676396cc2960595bb1ab222a49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3eeeff6d7b3312e6bd66a20976b56b8d6ce218432349e0b5c033bef25917bb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3a031f1ad78d063784809b8c086edfb9b92047ddae1c53ae6948debfc7e3e2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a14d6684860a6ef496dc5b65862ef0f29060d49292d96fd5a447ade69f862f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "432374a4bd4b58a1f7e8fc2b636236cc51629ed2dcd78489733844b5a4f3e632"
    sha256 cellar: :any_skip_relocation, ventura:       "bc9838edd6c20e8d284902868aa1e88d05199fed36c5726723d263fc21ef5eba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bedbbb60c02445c4637a38c8758de70b2d9f5e3ac19f4f3c181e361536b4f8f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3114ba22694e7c5f3b4cd24c016b5556fb2a570c461efe3cad27f27c34a3f63"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cloudlist"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cloudlist -version 2>&1")

    output = shell_output bin/"cloudlist", 1
    assert_match output, "invalid provider configuration file provided"
  end
end
