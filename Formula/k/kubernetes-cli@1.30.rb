class KubernetesCliAT130 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.30.12",
      revision: "66f4b3fc7966ccf5faf8264b1fef9f63b83a8ef4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.30(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "162182a6fe0e82e5fae2334e67a9e62bdf890c9aa550684ec38b500d201d32bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab5c66b806fd6573c2a95d962c66ccd97f2f52221c6a969c784eb545afae0daf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b58e9b912f575119493d8c7f349d58b71ce8fd67545c1da69ccd3b38c4d2f701"
    sha256 cellar: :any_skip_relocation, sonoma:        "8705bbe27349855c0e08b5ce599e574057dd217dfa86c75bbdbece8746ea242f"
    sha256 cellar: :any_skip_relocation, ventura:       "cbc88e18d9a31400fd5dfd4831b5c1a7fc719a5a098d54616fd1ec11ade095a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bff9b2c70be90ae45c659a6f9705c7e984e6888bae28c97df4cb58b87a8ac7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91534e0ab864d63b592e6df2025876623fd5c2dde1b694a7fda9774b8c0a2f47"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-30
  disable! date: "2025-06-28", because: :deprecated_upstream

  depends_on "bash" => :build
  depends_on "go" => :build

  uses_from_macos "rsync" => :build

  on_macos do
    depends_on "coreutils" => :build
  end

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin" if OS.mac? # needs GNU date
    ENV["FORCE_HOST_GO"] = "1"
    system "make", "WHAT=cmd/kubectl"
    bin.install "_output/bin/kubectl"

    generate_completions_from_executable(bin/"kubectl", "completion")

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
