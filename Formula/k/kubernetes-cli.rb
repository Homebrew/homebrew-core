class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.32.3",
      revision: "32cc146f75aad04beaaa245a7157eb35063a9f99"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7a07d2c83dec6272531c92d58cc7b9a8217acf1ce0f6fcda31007573a977fb7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "850821d149a9923573034e59c880799a71151fcf19c84d4cbf59838e29d46e16"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "720041563595259ab615c89036a3e0cc065ef3f2df0371bbfd4f9b1fb7debac8"
    sha256 cellar: :any_skip_relocation, sonoma:        "be40a927d56b9b0238a95c34f80250c3ab47c729e149bbf8085da642e8cb32e3"
    sha256 cellar: :any_skip_relocation, ventura:       "61bb47251d1b0121dda6a0fcc2aa115a3c198bfb7a17ddbe0f1835b09e18a493"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "211df1122eea354be1afa7452e5b15e2909e94362d7d19e1be5fcb660606103c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6aea7eb34fed51c8d5823f010bec328e465f377568d362bed1577f27b5c1ab37"
  end

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
