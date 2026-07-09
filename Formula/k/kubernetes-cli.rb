class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.36.2",
      revision: "24e2b02af5543d7910c2bb074c7264df5a8f0467"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91df548e1cb396ef67e3a99aa2832777e7ebcd56e0b8050a981a9dc8f1234002"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cf9ef220adef51db3f6835f0b4c7fe0b322f593c668753e5635566520ed06c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ca5116967ba01c8abc7c03019bfc2bc6599efefe6aca4dc2a913939ecfb9082"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c4452b0a565b7687f2c374802d19c794b2c192db0ab1da264052e9c8a5cdc11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee8cd75eacc68081c0a08b4d038c5f61fb08d16ae45574e07c870c12ad116661"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85ab53660f7b8edd92dc7e851191a8474ac8bc19f6281f8f0e02a4c777d494ea"
  end

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
