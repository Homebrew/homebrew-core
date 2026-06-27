class KubernetesCliAT133 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.33.13",
      revision: "c029d48d28322ad0369aabdcf8b656fd3195cd30"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.33(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42a09e00b253c7edb43a8276717773865ea7f0b42f6fbf8d3ef1a9b0c6b8e8a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11f809ffb9c2656f1fa11acadf1a105be7211ee7a5c7b48da7f90e2d8b7d6bd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b3742affeeabb6b423bc1b9307091f83a3a201db2557747045f160ab0c437f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "d552e899da8bf4e9bd376bfe29f34dc3b752c08a74c00b1ac23880f295333dc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6796045b20d2ffac1dfa80e2dd4b3855b47eb0b8526db44551914058c4e19dfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1be94fcf7a752dca877c8595133993104995b02bf04599352c4504dee1431216"
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
