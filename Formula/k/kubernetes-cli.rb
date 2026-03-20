class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.35.3",
      revision: "6c1cd99aef09161ddb07b8ade6c9564e9b9bfe27"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06705b9fa38561f0591f4332ca1233c591962cc0a0ab04eac5e2f9910ae86182"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d2dcd44bd15b303dc5d534130d387d4954b979f97a76ae4b3bc769635fcb0de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "531215a82b691fcf8e3d8f18f724518d4f369bb6d5ab45dcf141fd48f999c019"
    sha256 cellar: :any_skip_relocation, sonoma:        "5522d91a3a346e938053a9bd88981396202061f1a41227b0db296a923db89a1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e29c1d72d34f1a44ed6bafd005fe10f2d62b221a13e6eb0d6adb96f6de7e3bdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16497278e5bcd326d2d9e7982969a1e807d4f08b0f24b98f751f825070fe8b26"
  end

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
