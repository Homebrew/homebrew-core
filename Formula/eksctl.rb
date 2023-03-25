class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.135.0",
      revision: "8d9c9c3237d3d02f3550c2a2f0dcb27a88f97eb4"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48554c96a38d7bd55c5dceab2cc4435b229937d7bed68ba99297a73840418858"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20d97c3856441ad6cfd9fa9092e02d42e03ca41aa3a5a89fa8afa625fb7ece44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28c91ed9761b19baf7edad0aa64e61ad54ac9d28c5265808034af88fa36e5b28"
    sha256 cellar: :any_skip_relocation, ventura:        "3020c4b6128596e159605d97a31e6f16ef4987a61c94d5cd10164eeb7616d4e1"
    sha256 cellar: :any_skip_relocation, monterey:       "18799d08557a25763d7440918af13413a972f3ebd8a6af11f838d4537d0960d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "595dec0101601f0133fcbd091cdbf26d9894a79f10c22725baa812cc6c3cf0cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c2c230fca8d1268e32b2943d1fffaea8328d1c8f1a28ddfcbbab0091d3578ae"
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
