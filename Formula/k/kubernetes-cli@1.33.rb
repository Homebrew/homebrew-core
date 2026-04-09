class KubernetesCliAT133 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.33.10",
      revision: "51a8c572b0b772e854aaee790692d0a3c6aa9de6"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.33(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55636a4e456415a8de4f2824b5b1fed905421d1ce8e31156f2561c4f57d8b575"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "091ceeba0c410717c4ca5c4069897e897d1f895997a4f03f4bcbe88bb8d8cd46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5b0a2167d0c1f3d8cf2a6706377c893e2d2205e4d21fea3e9a1ff2a62fa9f83"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a5ed41e0bc4c60995456c1ddd8bb789c0092927441685e5888e3e566de27e87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed6a80c951e52621ea29c4f9a7b17a857ba350fab9f6d58aa4f086cde9d3bff1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0697f5dab2ca284ee47a5dae969420642359fb02a1eb7c243b047a2fee6ae437"
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
