class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.36.4",
      revision: "bb826b1d48562f110659e64e8ec444327433db95"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d323ca79a98620e42213203b325fa65517280ec29359ea92b7e3a8a9ec1e93c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64f40b1115c71ffb05905bda1f3b4ff1a2bab7498246b715f39ea5645ef1922b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45e8dccb6fb540850d724a2050a502549cb1f3da87959e2b19152702b62b142c"
    sha256 cellar: :any_skip_relocation, sonoma:        "43270e71f53e5b2be4f6a1abbf9c5edeea4058b70c88b1dd9a0e95ee738c6f5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e98ada543cccc8f1ff303441ccebf1882a0a2857a44af40e0c527f0ded60664"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdde2367cb05ce6ce7e8daeb20247d227a547a595875ca06a145b40176054d5c"
  end

  depends_on "go" => :build

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
