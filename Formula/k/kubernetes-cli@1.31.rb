class KubernetesCliAT131 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.31.13",
      revision: "c601ba40fa8f2254acd93bb31a02a6eb24948ec5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3444d7fc348142b9f1fd9f0d69728cf66eda892e29c7fd9b681e046192aac073"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d65fedc0ae66730654f1cc21d03b43235489900d71cb15cfd4dd1a30fa6f032b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2574c026de1bb94fede252c3f394f51525ee9485c164f3189f2274994c33296"
    sha256 cellar: :any_skip_relocation, sonoma:        "07dc3c950692aad156c2b0dfaee07095e6da3e3786fef886a36424999acfccfa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eee5079dd65a734f840d82dff5b3aa2c8192752248fc1f17013afeaee33ba0d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4e255e56420ea8a677fa9df63b98e7e982435e8098190e2cfbf17cf7ae2e63e"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-31
  disable! date: "2025-10-28", because: :deprecated_upstream

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
