class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.128.0",
      revision: "988e9835dafc9dcbc7c4980f61ad2955a7615a48"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c95c65d93f822b72f0c5c1e2f54f628b1315d23318c529248c52791209a0b1ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d2bcc83f3f71741c141067fbaa6b8fb79332958965a28613750b6ea63205d82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10a8ddde729ede649225a80959d6813bab4a2fac9976696f74482df3ecc5ad21"
    sha256 cellar: :any_skip_relocation, ventura:        "8f11207d29db0ba68fc5d24efacb7d9d76bc76795830b5d4c9076d298ef6ddf0"
    sha256 cellar: :any_skip_relocation, monterey:       "da6ac2f04e4cda9de2178b257e909f25a430953be1a2f613f05b24ff59c5bec3"
    sha256 cellar: :any_skip_relocation, big_sur:        "8cfbebc8240376dd8c3fb028836a260728e3f62332b169c9bc6edada8454d80d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fd76c1c859d35962d9f9732a1eca631a7aab7977d61535bf4df41cc6f0a1682"
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
