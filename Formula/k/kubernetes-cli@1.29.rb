class KubernetesCliAT129 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.29.13",
      revision: "9a58e9398d4aa69d7ad40f40407e54b96025e0c5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.29(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a05c0c119830bab7a84d239cd6ac9c72b99f5084fd47acd135c0c86a0586f9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b20d6e6b1128f0cf9d357505b96485660ad73bf0cda32ad180c6b689cc82f7e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8ac5e4605cc78867cf48ecbb190a2ce086a8b8527892882c1cca6139b21e3518"
    sha256 cellar: :any_skip_relocation, sonoma:        "56a26635ea0060c91ca066c18cfa661615ecfaf75d2c6d146791307590cc0296"
    sha256 cellar: :any_skip_relocation, ventura:       "ac6de77c126f867403695c3ab8c1ac35e23237a009610683802d0c04c26b4bc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ad0e957ac822c9e3b39d0a4aed13801c3133773d361da73cc2363dce20dfe66"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-29
  disable! date: "2025-02-28", because: :deprecated_upstream

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
