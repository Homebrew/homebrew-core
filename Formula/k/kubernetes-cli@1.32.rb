class KubernetesCliAT132 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.32.8",
      revision: "2e83bc4bf31e88b7de81d5341939d5ce2460f46f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.32(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5b0a71047a41e69432cfff298cf1c9c6f1865e0f22c6cfa49493771fbe72d0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d7cf142f209ef1d1e8283a22efa19c83bd795cf18bc98946ff79f8dcae71418"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "432c0685d5e9ccc5cb60ebb0665ffe32549903c58cb65f412d430d895cf19649"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3b86d91bf17865ffbd0823b3972bdb80e5296a44daab6fec34f23c745c23736f"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb9a6ea61eeb9c3db68d4c32ca5b742cd1466c2171b5ff7055c6e4824a00353e"
    sha256 cellar: :any_skip_relocation, ventura:       "19b3a99824393b7ff96481d275f196c150fe5a3a6263bb48b9ff6deb5713197b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fcf6a3da6f44103c5bddeeda3814c91225d453a9b3628013ee1a9cd523466c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e56336692407bf47314cd57f7d23b250d37d49161d2841681a7f7009fc9a66c6"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-32
  disable! date: "2026-02-28", because: :deprecated_upstream

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
