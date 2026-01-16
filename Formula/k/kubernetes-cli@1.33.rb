class KubernetesCliAT133 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.33.7",
      revision: "a7245cdf3f69e11356c7e8f92b3e78ca4ee4e757"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.33(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f392e80c14bd965db4971d1ac250eae6009f2bb5049927ac33fbf90c04780fd1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ec3a672da6f155ff6d99114d43d6b05225f314579022c239be1419149d58c7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37abbf10f1ae0230bdc4f425b2d36d701c3abce48939de0cfad3a916156f3b89"
    sha256 cellar: :any_skip_relocation, sonoma:        "32ad8bb143c0d23ec23469042f1c532dfafd0666b82d4468099360364b2ba1d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5aefff89784ce66fc65355b3df6ad6ec4a420330039c62cc6d0029d89ca48343"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49448035e997b69fc7d7005fcf5eb2ecd63161dc20323f25a8a951fc4508570b"
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
