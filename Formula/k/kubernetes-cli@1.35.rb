class KubernetesCliAT135 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.35.6",
      revision: "fc0e7a6ca50f7ce368f9a5516e1716b473ed3a26"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.35(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "500da6365c76c0c0f9ab1813de4ef876d0cb43c6937251d771e08e35807eb3c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "611882aa7d90af24eb241595f85e312716478e56cd83bfcb96a1a553a188204d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4861ba25ceb2edea6ece315a17e38b79e69c8545e9fe079df516c08ad4a44243"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5cd7a316da7a8d01a25a62bd37086d83e3b14d988a2ebd9f7444d21c2d2a65d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b641b1dd95c70f55fbc231c99ee5dc5dd1f04c084f9ad0e4632d18bdefdda747"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb469111bc17a6431968e81320fbf53737008ad545934e5aafaf1af02072feee"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-35
  disable! date: "2027-02-28", because: :deprecated_upstream

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
