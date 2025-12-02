class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://github.com/akuity/kargo/archive/refs/tags/v1.8.4.tar.gz"
  sha256 "7162cdf57815d7cb84bdd14fee07436dffbdc8cfaf527969ff9473cc7a144d6c"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db05ff79b0c8d6615dca052833623cd91aa3b99bc7f0e40c053cf3443d4e45c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a136614da14f2ad7376601563aa8327d8a05f113b657021eef59c6ffe93e120d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5166c5cc4b55e27c703d912eae0ff3db747db08356d6296a2530d2c0c9736485"
    sha256 cellar: :any_skip_relocation, sonoma:        "162d73d31eccb55423bca5d1fea0ecbd279fb1ead2e884948ae29a0479e264f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ec0b419f836aa26899464d68bb4464cf9ef75eb6fadfb15b6f08bd92c96cd8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c521a52133de6b2db3ec68d7b899872b49a9fa327cbaeff213085557a300e2c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/akuity/kargo/pkg/x/version.version=#{version}
      -X github.com/akuity/kargo/pkg/x/version.buildDate=#{time.iso8601}
      -X github.com/akuity/kargo/pkg/x/version.gitCommit=#{tap.user}
      -X github.com/akuity/kargo/pkg/x/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"kargo", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kargo version")

    assert_match "kind: CLIConfig", shell_output("#{bin}/kargo config view")
  end
end
