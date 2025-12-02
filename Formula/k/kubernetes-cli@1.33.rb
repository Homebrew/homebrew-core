class KubernetesCliAT133 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.33.6",
      revision: "1e09fec02ac194c1044224e45e60d249e98cd092"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.33(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e30c8a7fa8ec5ad64836cdd5b6f7ff9ef167b9332551388d1946955624fe2839"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c516063672e571bfa0fde458d580dae2c8d89b11045e66eaa1af9735a4a6dfb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c2b3a1b1ba8a0d26cc3c6517e6826b393de466faa174d83355f330e28416ab0"
    sha256 cellar: :any_skip_relocation, sonoma:        "db1dff098f7e486b40ced3a435137b25729819a1743302f93ace064281016f5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "896911955f984254d335dae55f39c111bc2e76400921e275b61b9e9e0167a80f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a84899893a7442100f36f8e843ee63c3865f60f0388d6e1bbe4c2e0ec56df3c"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-33
  disable! date: "2026-06-28", because: :deprecated_upstream

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
