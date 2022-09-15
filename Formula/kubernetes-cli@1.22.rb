class KubernetesCliAT122 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.22.14",
      revision: "bccf857df03c5a99a35e34020b3b63055f0c12ec"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.22(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbf4b795ffc28196b98d1b148ea979b8448d3b4c86c1b210ffe1767fc09ac57d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb3cd294c671ac2950f77590fe7dc0d1c6d05a2d07feb5ca8ebdc967bb426d19"
    sha256 cellar: :any_skip_relocation, monterey:       "f4cd1b20e2ce6d16cbae70fb0f3713dad1256aefbd1ca7824eb3fdfbb42cf372"
    sha256 cellar: :any_skip_relocation, big_sur:        "383be66eef4e9b2cdac009c3001433f445ce89c56b8dcd220f1c54f9a4b4323c"
    sha256 cellar: :any_skip_relocation, catalina:       "53ff4e79ce72314169a6dec8b521eb6cdca3631d313ab6304289b00f6ff3dd9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b042d3fcad75ffe5736715f4a8af37de1fb08f5438847b33128a7d06a821f137"
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
