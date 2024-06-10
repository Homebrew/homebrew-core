class KubernetesCliAT129 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.29.5",
      revision: "59755ff595fa4526236b0cc03aa2242d941a5171"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.29(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6e1a5e12ee6437c84153bf01dffe1e407b259c574fad1fb93420272dd4f11c05"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b81cce615adaa61890df2f77c7323b4b801a0a3e8c7336025d2e9cf7f3255f9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6aa8ddb327c826d7ad0298d0c5b20ffd5abe4887ac819c457bfeb261dd85ae6"
    sha256 cellar: :any_skip_relocation, sonoma:         "00fa144310316b440dacd98e89e8c191add1cfbd9467084b10c0d8b578e74270"
    sha256 cellar: :any_skip_relocation, ventura:        "c3fafdce37fd87b7b9baf730df8f40e44c56b75fe71ead0c81fb0462befd48fc"
    sha256 cellar: :any_skip_relocation, monterey:       "aa633618bafd5b1ab761b87f00693e07b2eb6137ebf4f4aad3e61db7c7fcd492"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "850d90b043eecd17086277397f23c0d31881eae98855786d1f52e80e9a7bb6c0"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-29
  disable! date: "2025-02-28", because: :deprecated_upstream

  depends_on "bash" => :build
  depends_on "coreutils" => :build
  depends_on "go@1.21" => :build

  uses_from_macos "rsync" => :build

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin" # needs GNU date
    system "make", "WHAT=cmd/kubectl"
    bin.install "_output/bin/kubectl"

    generate_completions_from_executable(bin/"kubectl", "completion", base_name: "kubectl")

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
    if build.stable?
      revision = stable.specs[:revision]
      assert_match revision.to_s, version_output
    end
  end
end
