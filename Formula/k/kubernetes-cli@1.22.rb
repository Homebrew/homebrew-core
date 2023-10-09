class KubernetesCliAT122 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.22.17",
      revision: "a7736eaf34d823d7652415337ac0ad06db9167fc"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.22(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4888e246ca781b36e1d1c1d015272dee446dda2659c22ac14f3d4f31ce11ecee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b223d96b8db4ab81508a62b4f47419349bcd15c95dd7b9b3b2c4bcb1708ad908"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7d2e3b120e9c0eacdbae66b56938cfc2bb97832a32be381e0aad68292f9d9cc"
    sha256 cellar: :any_skip_relocation, ventura:        "28e7487048762d2cd5c7d1089acceecc6469d34ce35141fb99434197b6f7582c"
    sha256 cellar: :any_skip_relocation, monterey:       "9270c4e34f0a5add2a28ef857260fa8c19e8fead25af3fa42201e29ac1868c8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "b07c67f09dbc9e9b13d436c0bc398327e2b666fb6d5d8e3b4d9c2a31893861a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5172c1c631fffc42c1c13be38f1220b935f42d385f40404d595969091140a6a0"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-22
  disable! date: "2022-10-28", because: :deprecated_upstream

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
