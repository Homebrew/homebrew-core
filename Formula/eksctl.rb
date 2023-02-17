class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.130.0",
      revision: "6aa905e1aaa07d553aeeb5c4a1568c0430aaf803"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee30dd694e9341d167196fbb728b822686da2c3b59ab78518e2b1c754f7c029a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61c5c2cd31532ac7f261f538259d9ef3553a0dc44c181ab1d617cd185f8015b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65eb62ff729a945b6e13a98a01550998ed3fe3341757c3d85e64b5ccfbf1124e"
    sha256 cellar: :any_skip_relocation, ventura:        "78cb5f4c98ffb30b1f5d382d1c6fe3559df579838b9e95db2f9bd2420268e013"
    sha256 cellar: :any_skip_relocation, monterey:       "6c60e152a9cb2f0e0cd909adab0326575cf02e72b188ae41b8f23c1653243c1d"
    sha256 cellar: :any_skip_relocation, big_sur:        "6564c45e6ab0ac7a3676692acb438b9c91d50f84cf84049f98fb4db422c5592c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09880b82188e2f010935befb2a4a0df182a4887e2c277fe85c967d8afaf8eaa9"
  end

  depends_on "counterfeiter" => :build
  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "mockery" => :build
  depends_on "aws-iam-authenticator"

  # Eksctl requires newer version of ifacemaker
  #
  # Replace with `depends_on "ifacemaker" => :build` when ifacemaker > 1.2.0
  # Until then get the resource version from go.mod
  resource "ifacemaker" do
    url "https://github.com/vburenin/ifacemaker/archive/b2018d8549dc4d51ce7e2254d6b0a743643613be.tar.gz"
    sha256 "41888bf97133b4e7e190f2040378661b5bcab290d009e1098efbcb9db0f1d82f"
  end

  def install
    resource("ifacemaker").stage do
      system "go", "build", *std_go_args(ldflags: "-s -w", output: buildpath/"ifacemaker")
    end
    inreplace "build/scripts/generate-aws-interfaces.sh", "${GOBIN}/ifacemaker",
                                                          buildpath/"ifacemaker"

    ENV["GOBIN"] = HOMEBREW_PREFIX/"bin"
    ENV.deparallelize # Makefile prerequisites need to be run in order
    system "make", "build"
    bin.install "eksctl"

    generate_completions_from_executable(bin/"eksctl", "completion")
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end
