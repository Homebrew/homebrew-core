class KubernetesCliAT132 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.32.10",
      revision: "d26b18be2afac11e4c4d8ed97997baa012acabf2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.32(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8a934aa6d5d8f4570e90a5738a4cf0e0350b5dc39fbb84e6e73a8ed7a73fbe0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d60bef43123f8ae150d32485f33aa6715e2c23ad0c6974d7cf5d2fabbf2b437"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ace3ee0d81f1eb23acddd7fa455dfd7be75255fb55825f63deaee450f8c90b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "da9173d30c7bd4a2938daaf1fb126924616134a8034dbd85393053014ad6e325"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45357ffa08b246b604c1a8fb8f8d714f2314040f1cc73c71be2690a06749ad3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d77771209e01c0bdbb889c6aae8f15c52d31bfae7ae87133848b733ca9d2c17"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-32
  disable! date: "2026-02-28", because: :deprecated_upstream

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
