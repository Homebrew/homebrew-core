class KubernetesCliAT129 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.29.8",
      revision: "234bc63696ad15dcf62584b6ba48671bf0f25fb6"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.29(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf73433b813ff874845eaf23c48bf892cf7334b72b1276a9f5eccb93e1274866"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a3e63af3958bc71790c19ee4218361c80120733b7fe4f033fef87a94d814f04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eab5e0836017cfbe9d5f6a0bcafcfb2d3235e4f60512cc66021166fca76fd6a5"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa6f84fdfe525c7b790c6eb6a064f2a064be4411ce486b28a5be0e4e0a190c7d"
    sha256 cellar: :any_skip_relocation, ventura:        "1a288c1a725364e6392e535b1a8ebc3d6d37ae6f94fd5f5952a1fc734bfca7d6"
    sha256 cellar: :any_skip_relocation, monterey:       "0c237fdc352238477243fe9a8a9d09bd2254c36bad0f11c03e5945d942893ed4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "470a9d894cadf1bc6f706f543780d5b0e36c31103a7dcd55d03488d36808c870"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-29
  disable! date: "2025-02-28", because: :deprecated_upstream

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

    generate_completions_from_executable(bin/"kubectl", "completion", base_name: "kubectl")

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
