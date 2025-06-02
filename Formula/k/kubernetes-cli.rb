class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.33.1",
      revision: "8adc0f041b8e7ad1d30e29cc59c6ae7a15e19828"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dfe3b28b44ac119c76b7d68396eea2dc5715208317ba8d70024a292908a66795"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee2df9d9511bdc5b3a7e38e6427d0aab88ad999501d727032828dfbe751e0ef8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4446ef3c48d701b20eaf392eee1a83c815f394bbee6168d8b481e0805bda603"
    sha256 cellar: :any_skip_relocation, sonoma:        "fee0b134359e6e6f7cab5aace688b3eed584b771ded17ee2da6ea7c8f0a44c0c"
    sha256 cellar: :any_skip_relocation, ventura:       "6099cff31f345023541bef208efdf936fa8888f2666ba39c3ba197dd5f75517f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8003784d44c5a4db1360535383ee2b91f1924ec14dedf8d6ce29cd59dd0823b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f253773fdd67c1a68f07b59f0a924b5b88d3b091f22a6f9c7f377261688f3b4"
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
