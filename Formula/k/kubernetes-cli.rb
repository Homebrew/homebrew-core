class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.37.2",
      revision: "c50e5395f1ae2d4a2c05f28fdcc38c0916cc1a32"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "19fa72010a3efa84080687499c8441de281378bc24f280c412729bfaf952d1af"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2b02c5b0a81511d5a628d1d82bb4ce5f7ec4dae92e993488d4cbbffd4a38d675"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bd24a83dfcae56ce91c8690d101cf9913f565d2a13414efb2b3a1ad665ba8cae"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9d880c5141d548efbd65d1c9cebef78cf656e9530a162c45ace225df5b765fbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "287b99637cc942686895d852bf05d4be0a87c99c6333963a0dc1c1c62a092945"
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
