class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.33.0",
      revision: "60a317eadfcb839692a68eab88b2096f4d708f4f"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cbf01387b2e22e797e23bdd20bbc739eeed94e7602d2960f4d14e9759b9e58d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e24f2b786f03e73817040d1dc9ff09f05e9d3e6154fb25b0970ecc0e561527e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "587c59ca1979dc3599256e6cc4f4781df7d54488406e91a5b30e1215d7e92666"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f7f73d0cc22396a7e73f2b462e09cde6d8e6cca7fc9c417963f2bec37bd27d1"
    sha256 cellar: :any_skip_relocation, ventura:       "701242613095b28406bc2dcd5f653125ea8a9e179468c8940eb18d78dddf58b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34f7387f62bded778a26334cc6c1fd29f4be08ece33d63f4db3711023bcff556"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6852141de082462837b4b5c6990a9a059c8987b7a48ad68a561c9011f08cafde"
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
