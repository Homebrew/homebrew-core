class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.25.4",
      revision: "872a965c6c6526caa949f0c6ac028ef7aff3fb78"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "797fa6ff1eba4830877041c7d33d2143c1b6d849627f4b1935dffacc6e747741"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c518e35f745195cd09311c0da201faca1678898e0a6a227aaf5a12cfb78f2d04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b636ca2f7a8997012770eccd5581976cdb00762b3374512f4f4619a1b4304555"
    sha256 cellar: :any_skip_relocation, ventura:        "2f5b488586030d18502b466da63590c9d6dfb1ff9ebf8936e63f13d7ac5cf112"
    sha256 cellar: :any_skip_relocation, monterey:       "a907d2c257a1219618ec8e21d6cd041ea001b30a06f638dc8842621a1a9d8da3"
    sha256 cellar: :any_skip_relocation, big_sur:        "64d895303790696067ad521617f7d6f6df810ebc76236001e058d1219542e2f7"
    sha256 cellar: :any_skip_relocation, catalina:       "c00fdf8ef0bf56a36f1087c6d29f78ba1bd9b2fa109da80b5a003715c546b695"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "229d67cf898b8a38bc2c62eb709b768422ffd5f22d7f563cbe34b97dfd0994df"
  end

  depends_on "bash" => :build
  depends_on "coreutils" => :build
  depends_on "go" => :build

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

    generate_completions_from_executable(bin/"kubectl", "completion", base_name: "kubectl")

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
