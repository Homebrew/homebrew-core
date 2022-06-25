class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.104.0",
      revision: "6f5ce91222bd53aad2fd9904c3da87bdacb1105f"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a782bdd239afa4b93e365f20ea5962340ee5e8dc1bfd88133da5fc208ee746aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e9b0112c5796e2dc91f2f467d069ce2da149d222082ce32f8d7be0455a2e088"
    sha256 cellar: :any_skip_relocation, monterey:       "7253c70b2af84f5937761826b7d23bd32a9cd21909b7542f0d7bfcbf7c85b254"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f33f175f605a343b34adedea11d67d76106ba56357c1027fa1ab0a90dd821ac"
    sha256 cellar: :any_skip_relocation, catalina:       "d62c48b88071abed00cc4a8415a7b75759d3a1a29635b0e2ef179c330763de8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0deb6f0aca94ead3941f97e0bdc6797f31cd71ba7011cc47312dc27129543f2"
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
    system "make", "build"
    bin.install "eksctl"

    bash_output = Utils.safe_popen_read(bin/"eksctl", "completion", "bash")
    (bash_completion/"eksctl").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"eksctl", "completion", "zsh")
    (zsh_completion/"_eksctl").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"eksctl", "completion", "fish")
    (fish_completion/"eksctl.fish").write fish_output
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end
