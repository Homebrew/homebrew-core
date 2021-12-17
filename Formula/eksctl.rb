class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.77.0",
      revision: "d7e5bc8cb027b6b44aaf7c238988e29a354bf913"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94727bf0afa07166ea71768ddee5c07f96f12b33cf82781ce9583a95eae709df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "613558e51f8add0ccf0a15aef05670db502e323570d38da66cc6980cc208655b"
    sha256 cellar: :any_skip_relocation, monterey:       "388fa7a99e7d1583d7d1b99ac9b4af8e8823dfb64572c6eca97cf9ba580c0db8"
    sha256 cellar: :any_skip_relocation, big_sur:        "879118ba340cc0822db3ac60f266e5839e5cda0313871b9299262a4235629984"
    sha256 cellar: :any_skip_relocation, catalina:       "8b8606333048c70226d4c600b04a56851bb31d97c613dfd07c46b499c4441d74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd99519e79745c36a4ea8fd4cf55c3357316115be4c7af36be00dd8eadfa29f6"
  end

  depends_on "counterfeiter" => :build
  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "mockery" => :build
  depends_on "aws-iam-authenticator"

  def install
    ENV["GOBIN"] = HOMEBREW_PREFIX/"bin"
    system "make", "build"
    bin.install "eksctl"

    bash_output = Utils.safe_popen_read("#{bin}/eksctl", "completion", "bash")
    (bash_completion/"eksctl").write bash_output
    zsh_output = Utils.safe_popen_read("#{bin}/eksctl", "completion", "zsh")
    (zsh_completion/"_eksctl").write zsh_output
    fish_output = Utils.safe_popen_read("#{bin}/eksctl", "completion", "fish")
    (zsh_completion/"eksctl.fish").write fish_output
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end
