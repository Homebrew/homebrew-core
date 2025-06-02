class KubernetesCliAT132 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.32.5",
      revision: "9894294ef13a5b32803e3ca2c0d620a088cc84d1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.32(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a952e20d204828e6f09303a4d6a081fc33021083f0b5a1867b8d110af9708152"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62f255eaa5a050170c462aaa7adb619cc94e54e493758fc347bece8ce89c3508"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d4ef73ae8dadee8cb918c6447c84a0c49648ac7fc9c50aa39c52d244014486c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "83d4eb3ca7a917062434aae971ba36fffc754eb0e34581f48f3b0a32c7556548"
    sha256 cellar: :any_skip_relocation, ventura:       "a7db4319d771635a022a127dc16e1e25a7b97d8468cb4b2333c8e19d07aa34df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "861e5214b8d2a481a4cc09702665fd155b20d25e1dee1feb0c58f8062db3aa76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b05c0170776c709fbdcad65588e4bedb20e3a0091b11e970b3d99dba97ad112"
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
