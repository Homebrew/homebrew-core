class KubernetesCliAT122 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.22.6",
      revision: "f59f5c2fda36e4036b49ec027e556a15456108f0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.22(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "807e31153d9e416bb34207c4c12083ffbaf9d7d974765df25d0700923c57fdb1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b69a15bf1032a18501ae7fc47f26fcd29a9ffaf8046da0bf04205b0c29e65114"
    sha256 cellar: :any_skip_relocation, monterey:       "b9e7b22e525fb4e3671fcdb292b176be0fbc1110f09e3b59daf4728c28f1545e"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2e62905c7764e0a0c2a6e0540ae74a889c3caad165f43c0c3f8e14ff9c0661f"
    sha256 cellar: :any_skip_relocation, catalina:       "24ef2b0147151a2b06ec011a2c9015c4e20c2134e583ad33ae6ca4307ccd49c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc6590b6a72fbae7136cba6ad3822e7182ae4a678003efd99c573e27341f08ab"
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

    # Install bash completion
    output = Utils.safe_popen_read(bin/"kubectl", "completion", "bash")
    (bash_completion/"kubectl").write output

    # Install zsh completion
    output = Utils.safe_popen_read(bin/"kubectl", "completion", "zsh")
    (zsh_completion/"_kubectl").write output

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
      revision = stable.instance_variable_get(:@resource).instance_variable_get(:@specs)[:revision]
      assert_match revision.to_s, version_output
    end
  end
end
