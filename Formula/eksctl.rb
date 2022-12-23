class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.124.0",
      revision: "ac917eb50b9ae6dc4b4098dc2074b9407f2e2b01"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30820e6b67a46b60d50e1fe12015bc833069af7592de415ccb431edeca5c988b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b836cb970801ed15fe05fb1e2184ac42b7b378b7b4c99ad79cc3290e0e8bf63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73d59a51268e6cea1de28df8d357efe1be472fa463241547475b84efe65db61f"
    sha256 cellar: :any_skip_relocation, ventura:        "e5d1def426a4c9a4975cc7cf9a0a780ac688e716b5df2abe3c9bb923515ed959"
    sha256 cellar: :any_skip_relocation, monterey:       "3b8a0838cd142884215f2af4fac3cc799642e5495c950c10198e913ae525a9be"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c2d5f61b24a52a8c959143b7e66c8580cdd9a577eaf7c1fefd311d090ffe530"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6d422cb4808cd0fb7adcdd76fa1f6ed57d983406df3e32762d4f6ee05c9794b"
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
