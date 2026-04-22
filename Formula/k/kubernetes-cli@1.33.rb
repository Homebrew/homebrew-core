class KubernetesCliAT133 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.33.11",
      revision: "9efa99e5a155c9af625d2e6271ea6f8514b24df7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.33(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "357c3a8d6b2cd6571b1b611ee67fda5d7088963fffcece900f66a482635285b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1804c00fff72744d82dd4bb1256d613fdb4bcef51ad845a3e398e1000d4aa22b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33e0117a5d29ef3ce067f0fac8a0274a820bfda1baa877c0d86eec9f8edadb77"
    sha256 cellar: :any_skip_relocation, sonoma:        "bba5af5d466c469a26398394a8a930dec10f1792ec897bba3c14deb4c24d4756"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8869562f5a7b7ded4d363bae1c18698f5c66d881361e50177e600269c6a997a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5db838cb87eddc436f011f4a3e7d52e46ef149390684c16f471c59da2badb971"
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
