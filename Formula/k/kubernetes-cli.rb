class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.33.2",
      revision: "a57b6f7709f6c2722b92f07b8b4c48210a51fc40"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1e2e5650487db8b2a2441e03804151fc26e2a342bbc1597e2a1f29c47140165"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cfe5008e6c454f126bcf07ae2cacb88059c7737a69d8cb715a173306deda815"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e1c408fe97060c290bd76a79b1a9fd0efffb78656ca508469acb0d686a4f49c"
    sha256 cellar: :any_skip_relocation, sonoma:        "549acf5b9b39a4b9bfd0ab94884235c90d21dcbada54984f973a6084f403a223"
    sha256 cellar: :any_skip_relocation, ventura:       "bbdbeb57f463197e7aed87e115d17d2c1015f9f3a16f082eb9cb30676a5fb702"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23d14ef66c11e7121af280fc1a3a2510f64dba0cc957f90e8985bf6f8671b80d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5369f9b4a339daf07240df0ed5683ee486bbd1f4bee170f463b0d1b0cc640821"
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
