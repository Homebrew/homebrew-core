class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.35.1",
      revision: "8fea90b45245ef5c8ba54e7ae044d3e777c22500"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3dd535e06d76d8f3529aa98e07ffa86fe09c932f8fea343fb9994de9dbd43541"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f631369e4801d1083c4dd597b1d53ef7039778e0f5ceb76817bbc72c1b0210dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c70e694bc9450b68dbbc44e6e79803a9b636dbd8c09bea2abb4c920a675602a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ff5f521b1cfbfc49e0638f90e359231402eb3586345d20a9bfdf929f317d9f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8432187e414c75cc70fdfc77d2069922a949e75401e7c079a03772b48e2c40e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24975271d2165572c34890433194d1f411947922aa933173ac9db56b778a30d4"
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
