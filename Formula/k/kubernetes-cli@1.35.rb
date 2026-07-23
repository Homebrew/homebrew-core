class KubernetesCliAT135 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.35.7",
      revision: "96cb9ab4201d88ce5e549fde047a686171838fdb"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.35(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f59802e0dac4555e0af26371a6841f61d334b80d91d3ed0593085b9f1fb96ca4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c6e62983d00d4f73b9dbc6d147320fe4256925188807d13a86c9283ad9b0e82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9dd00d163e95fed8f3fb52583e411a28a916e40ae5b43cb77d82c88bb3560fbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "92181ed80085c362be51153aa90cbca67953d90d354cca5aaa074614aabffada"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d08e67a42187ebb3cf5324a0b4b040aa131dbd04c974960ab28306d58e06084"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6c180c488b972714acdb0f0f0ba32add413b7fea231ae3afc931b0386a731af"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-35
  disable! date: "2027-02-28", because: :deprecated_upstream

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
