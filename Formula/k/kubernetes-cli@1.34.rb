class KubernetesCliAT134 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.34.8",
      revision: "1f328c5e9dd683d0c5e69f3d7d58f8371278dec2"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.34(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8fd1a5f30c89e6bf15e6ffb191af67c3c165f13959fa1e75a0901c63794eb5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3dd18683f24f9ce965afdcf4934ea41eca0962e6b85cbaf415da14083bd50442"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "373e2ed5b5705d5185670d303f2be9fec22f852171213a66b516eab0c3b5f794"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9d11930445ee9d47d306f79b96d938906bdad177f20872d055dfaee1bc4676c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41997f22a1b57d2621d1f3b489b5442c6a30f52431452dfc5969219aa2956a1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf120207f6c1a30d631a830e58723e22fde9e7ebc66d1480af787e6aa3a294ff"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-34
  disable! date: "2026-10-27", because: :deprecated_upstream

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
