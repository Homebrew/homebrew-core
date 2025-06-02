class KubernetesCliAT131 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.31.9",
      revision: "8f3800390d488f54f74111f22973059e133f9cba"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.31(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b868f3355eadb2dd769a00c1fd8a97ebcf987f301762ff462480b050255e2dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "390c9629b186a77d9f90779a7243c663f4da25b2c6ebac9e40ea6b63bffb02b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8fe29490ff60fb7c22043b8fd6c911234449af478e484970ae39534720b1f953"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c2e89e779fa6e217ba2130a9f17076fa84806d9de02042afa97c76a023693cf"
    sha256 cellar: :any_skip_relocation, ventura:       "28db6bcfd866cdc8f5eb4f02a0229e5900661351ebfb35dcdf1ba6f5ff62c952"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0fb8d7bef6dfd59e89f9316935c196fbd7b79cc82d379c4b7cb45e357b6cf0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12ffefa4495d40ae3887995b66586b4d5d40506040d48d2de31b2c14e6ad90c9"
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
