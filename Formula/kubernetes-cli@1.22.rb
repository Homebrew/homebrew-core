class KubernetesCliAT122 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.22.12",
      revision: "b058e1760c79f46a834ba59bd7a3486ecf28237d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.22(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "713889fd1ea2c3985797815d6324144f34a91c82d1878a8b0e7db17dd1042d84"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3d671db53f9551be639c3256be81a5bda4201a110e0b0cb752b73256313e723"
    sha256 cellar: :any_skip_relocation, monterey:       "723c00eec1d9efd1df2282f966cc0b2f3ef792b947918746e9f4d657d5a77603"
    sha256 cellar: :any_skip_relocation, big_sur:        "545ea1d4cdc3b00bb1a9caeb05c0bf809f6404b630f9a0f529ecbd837a0fee60"
    sha256 cellar: :any_skip_relocation, catalina:       "d1a8517e03b1cf26fd4b0e762e8729ad15e496710ab9ccccac06d4edc9d69c2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "deb51c3fe6fb446af8f2a942eaaf8599f933f8f889e465845694596f1032a208"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-22
  deprecate! date: "2022-08-28", because: :deprecated_upstream
  # disable! date: "2022-10-28", because: :deprecated_upstream

  depends_on "bash" => :build
  depends_on "coreutils" => :build
  depends_on "go@1.16" => :build

  uses_from_macos "rsync" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"

    # Make binary
    # Deparallelize to avoid race conditions in creating symlinks, creating an error like:
    #   ln: failed to create symbolic link: File exists
    # See https://github.com/kubernetes/kubernetes/issues/106165
    ENV.deparallelize
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin" # needs GNU date
    system "make", "WHAT=cmd/kubectl"
    bin.install "_output/bin/kubectl"

    generate_completions_from_executable(bin/"kubectl", "completion", base_name: "kubectl", shells: [:bash, :zsh])

    # Install man pages
    # Leave this step for the end as this dirties the git tree
    system "hack/update-generated-docs.sh"
    man1.install Dir["docs/man/man1/*.1"]
  end

  test do
    run_output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", run_output

    version_output = shell_output("#{bin}/kubectl version --client 2>&1")
    assert_match "GitTreeState:\"clean\"", version_output
    if build.stable?
      revision = stable.specs[:revision]
      assert_match revision.to_s, version_output
    end
  end
end
