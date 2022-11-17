class KubernetesCliAT122 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.22.16",
      revision: "b28e1f370a4a4c428ddbeababcaf0198f048fcac"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.22(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee27be6f90bb497243847c099b12a60641f633bef97f422b8eac4c939f4ed421"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1e72a67240b144bb24758ef788a04f002389a9210afff0f0fc0201986e1095c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "670cfb0dc7e977ade2e73fd8e7a6b63048033e14ef2520f0041dd14b139a223d"
    sha256 cellar: :any_skip_relocation, ventura:        "b95201d62dbc19f960b4f8224c91aa2d8ea86efd54eb2bd74b5cc93569a834fc"
    sha256 cellar: :any_skip_relocation, monterey:       "f380ff182e1cb84dc376cf88ccf4591a8b80a2b1cc0ee002c830b32bd0e7b7b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "1483a0c50214886a7613e65589e95b4c2f5ef45aa7843d96fa187c6e1d0b6b51"
    sha256 cellar: :any_skip_relocation, catalina:       "326de06339461f1ffdd60ef73ca565af2e08fd1e835ed8735431a1f4d63274bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0133a383decfca91556073e6ba0a3a16b5b2e1b86014373c7527ef3740faf2b"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-22
  deprecate! date: "2022-08-28", because: :deprecated_upstream
  # disable! date: "2022-10-28", because: :deprecated_upstream

  depends_on "bash" => :build
  depends_on "coreutils" => :build
  depends_on "go@1.16" => :build

  uses_from_macos "rsync" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"

    # Make binary
    # Deparallelize to avoid race conditions in creating symlinks, creating an error like:
    #   ln: failed to create symbolic link: File exists
    # See https://github.com/kubernetes/kubernetes/issues/106165
    ENV.deparallelize
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin" # needs GNU date
    system "make", "WHAT=cmd/kubectl"
    bin.install "_output/bin/kubectl"

    generate_completions_from_executable(bin/"kubectl", "completion", base_name: "kubectl", shells: [:bash, :zsh])

    # Install man pages
    # Leave this step for the end as this dirties the git tree
    system "hack/update-generated-docs.sh"
    man1.install Dir["docs/man/man1/*.1"]
  end

  test do
    run_output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", run_output

    version_output = shell_output("#{bin}/kubectl version --client 2>&1")
    assert_match "GitTreeState:\"clean\"", version_output
    if build.stable?
      revision = stable.specs[:revision]
      assert_match revision.to_s, version_output
    end
  end
end
