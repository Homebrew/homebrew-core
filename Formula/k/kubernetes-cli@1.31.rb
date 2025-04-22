class KubernetesCliAT131 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.31.7",
      revision: "da53587841b4960dc3bd2af1ec6101b57c79aff4"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.31(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cba14d29df742508f4539dcba4cb99bef865af3462822d4313b6af75c38b8e4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cd00ff859efcc88032c8a3b801ef62243dcc3e1285379810dbda082db9b68ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d149bef1a31372a83babf0a48be22dad3acf090d7c59bc54af87bc36cb2eb08"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d7f9dccd61203fc5721c6cb83c4d0f40e2363b246e28660ea66da46c567ec5a"
    sha256 cellar: :any_skip_relocation, ventura:       "b0730b9b1341b4301489ac3772dc0f66ed6672180ec9e880ae6df4b62835d42e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ab0876c13daad9e09fd2383839972b0df2c9822de6a8354197864e674fe7bc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74003bde3ab0aac1aa1433becb1f783cf37bd5179d2e8561d5fc247ab03056a8"
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
