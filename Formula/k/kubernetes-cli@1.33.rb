class KubernetesCliAT133 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.33.12",
      revision: "1f348c8e82cf0f170df4ac2b1e859ea0d398ff09"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.33(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0185e586faa1fa31fdd47f71f5aef81201dc8cd728039de6013aa591a460fb76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d4cde5b523dc195a95af5b7fbb616fb8299a4367e7839b867074074825206ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "360af7b4555792b93c3d686a1677747df8dfb85c88e2b7bec3b1e2b7183da028"
    sha256 cellar: :any_skip_relocation, sonoma:        "55f64f2fc78b9f19bfeda03a1626621b1870f549549f4dcae66dd5a57c21251f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5418dd0fc27de87347dcf3175cce6c5adf87487d181c98b32c6d1a1e11042491"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b297528444f4337a329ace2244bade58e8629e9ef21ab11ea81bcaecbd087bd"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-33
  disable! date: "2026-06-28", because: :deprecated_upstream

  depends_on "go" => :build

  uses_from_macos "rsync" => :build

  on_macos do
    depends_on "bash" => :build
    depends_on "coreutils" => :build
  end

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin" if OS.mac? # needs GNU date
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
