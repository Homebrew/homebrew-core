class KubernetesCliAT135 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.35.5",
      revision: "6636cbce3bbef91ff61d36658757179426f9e1b2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.35(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d896a19e527fe553910059b5bb294e149601ae7160f8107b8833861bbd80e88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6df5a0123d6127bf3c61bf7af0d6096f57958df84fd44791db8afec10dd9f6c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9490045d213061ae401fb7dc1c0db1b6099d345225170488a07e08b6052c755a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4d060589ee5488e748fce48a50c68fbc16ae5088fca49f4e4374b4efec2bb1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec2b5f525858811178a9b3c472f3b07d87ecd71dca8245dea742d209e19542cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e9a413b7c2d22372ef16eade2afaa5e445214df9c2ea9f1cf7b6ea2fee52d10"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-35
  disable! date: "2027-02-28", because: :deprecated_upstream

  depends_on "go" => :build

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
