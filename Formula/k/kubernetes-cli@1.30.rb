class KubernetesCliAT130 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.30.11",
      revision: "6a074997c960757de911780f250ecd9931917366"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.30(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "292aa0044fde2c6f700995f21267817433b11c27e09ed9a184d3939761181f91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5717b1660572ca5f6dfc8dedf446ff96346bb119f10eceba90b71410c79f887d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8fe20df39a45abb069c24eb5ef7b6db9dec5e769b659381c6442595557b4cb33"
    sha256 cellar: :any_skip_relocation, sonoma:        "e24fa35885715a5de8b21b28dffeece7a8573d1a91472c1a24f8b98d2075eda6"
    sha256 cellar: :any_skip_relocation, ventura:       "89f1462462d0c2c0343d81a0730fbc01074b969469425bdfd299dbf7980eef5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a703a087e72ef9a965d72c0f11841083b005dfe948ae225991d3ea0336f141ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b834df9438919ffa5a1f7f99d379c3d979c05212934fee5212adce7d2adc6019"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-30
  disable! date: "2025-06-28", because: :deprecated_upstream

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
