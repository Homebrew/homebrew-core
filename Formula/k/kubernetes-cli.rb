class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.37.1",
      revision: "f78e722310e50bcaca9276be22276d9e91d91308"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6f29919ed3e6eac28acbef2dfc818ab8b4e5bf0779ed393510ea3e0e96ff870a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8b0f055c752bf016c3c184ad540ebe19de13aa194c6ac7bd9c0f5eede97320b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0300e994f298be4e7b88c698684f88c38f41bd93f04161aeb9692ab4b48bf1fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a63a5406c21b17f43a8166bdf1ef8a5e2e2522260a65efeb021d0a7e129c07a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f9f7668844dbcc5ef1591ad248d9d1ab001d1fe1880593d2e912a22e6c732822"
  end

  # TODO: unpin go@1.26 when Go 1.27's ML-DSA ClientHello no longer gets reset by TLS middleboxes
  # Upstream also builds v1.37 with Go 1.26
  # ref: https://github.com/golang/go/issues/81199
  depends_on "go@1.26" => :build

  on_macos do
    depends_on "bash" => :build
    depends_on "coreutils" => :build
  end

  # Go dependencies are vendored
  deny_network_access!

  def install
    ENV.prepend_path "PATH", formula_opt_libexec("coreutils")/"gnubin" if OS.mac? # needs GNU date
    ENV["FORCE_HOST_GO"] = "1"
    system "make", "WHAT=cmd/kubectl"
    bin.install "_output/bin/kubectl"

    generate_completions_from_executable(bin/"kubectl", shell_parameter_format: :cobra)

    # Install man pages
    # Leave this step for the end as this dirties the git tree
    system "hack/update-generated-docs.sh"
    man1.install Dir["docs/man/man1/*.1"]
  end

  test do
    run_output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", run_output

    version_output = shell_output("#{bin}/kubectl version --client --output=yaml 2>&1")
    assert_match "gitTreeState: clean", version_output
    assert_match stable.specs[:revision].to_s, version_output
  end
end
