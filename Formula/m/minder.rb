class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https://minder-docs.stacklok.dev"
  url "https://github.com/stacklok/minder/archive/refs/tags/v0.0.30.tar.gz"
  sha256 "cc74639804975522013539caab54d00f4d81c44d37167da2abb84404a264c024"
  license "Apache-2.0"
  head "https://github.com/stacklok/minder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "04f7bca7ad5e6b463508eb48ddb87703a8ed45040afdd24761738efdad1562ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9e14a9945048b8720e2b9a6013a96fc235af9aab64072edaae7604f652fd98d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c61614778c3008f33adad7851ff6c32517352c9c1af20a621b3d44fc0dfb4d9b"
    sha256 cellar: :any_skip_relocation, sonoma:         "aaa1fd807c62bd500ee603fa1aaf0a0387798c0b1312745cdc6b2991f04b18e1"
    sha256 cellar: :any_skip_relocation, ventura:        "acf36136a38173d0c213aaafc8f7ddb854a6350195d36b2019a704ca550f95b7"
    sha256 cellar: :any_skip_relocation, monterey:       "e8b028aa23fc5b41a173187705469c0029547d9471807e5106d60b14007e80ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5ada3e6cb427a8ce60fa6ea8c5c6c9e661cdf556a115eeb525d95a7a7462f26"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stacklok/minder/internal/constants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/cli"

    generate_completions_from_executable(bin/"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minder version")

    output = shell_output("#{bin}/minder artifact list -p github 2>&1", 16)
    assert_match "No config file present, using default values", output
  end
end
