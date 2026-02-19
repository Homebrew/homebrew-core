class KubernetesCliAT133 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.33.8",
      revision: "5adfc48e19d5fbc4af5b0d31aeb9f0c13c01cf5d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.33(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a829ceb78b83365efa2f9d9d90d4b7a80faa3766ce9df83d547e7aa2bd714acf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e760fb2af48b2fd145e8c70fc64daba15edcb037feff69d396d522323c58d4e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02e6f7cd7b386f9cc82e207220c6b4819efd8c841fd2a2b26412467f6a817bf4"
    sha256 cellar: :any_skip_relocation, sonoma:        "eef6d128d298e5924d533c78ca39a868cb3dbe0a0ac88b3f6ddcc57df75acf39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cf26902ff19a9a350ed28cbef21c360e1ff389cc3643a247ece3a8a2b8429e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87734e91af6ed818a498f1a3eeef064a77031fa1937aff8d452251abf79c4ad5"
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
