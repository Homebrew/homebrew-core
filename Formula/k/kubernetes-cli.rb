class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.37.3",
      revision: "f81a9c5f95912fd97b7c8aa4966301aeae84a253"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "4e0059cf87b0f1c4ae21e2060d7a260a876f23afb1d81e490bebfe26db58b598"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "db7d4ee3969e211e6aa9f4dc3f8508b708512b6d9e5fdbcb968fe5c544806204"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cf5dcd66cb18fff02f8e976578f06f5c9048fa8fde3cc3370b47ff0b437e6280"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "06631a55bf5b9d0d0143166a4c19b580bb9579e92a81e1162848122e1544c973"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e134891e38325dc30507087058922b1e8886a4618054f38a0814941091bcd346"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4f3f28a938e200d6f181aa429025efe630c3462f0d5a921855f0dbc9f65114e9"
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
