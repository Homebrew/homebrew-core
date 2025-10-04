class KubernetesCliAT133 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.33.5",
      revision: "03e764d0394bdff662e960c70d25b3c30d731666"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.33(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4b9e5191873a4c381096e3308e96d276f26042f5c68e9ad40627f396075fb4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d45a746a520db238ffe1f780a01197dd7a3e579dcb732de0258562e596def9e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b4da1996a913e9b9b3ea8d03e5da288b98dcac00b3420edb34da033e2797c88"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d62c08ab56b721af04a8f29f3703cb67d1f12a8c9978fe56a557364fb8e8e710"
    sha256 cellar: :any_skip_relocation, sonoma:        "b58bcc53adaf20b5a86305c65bfb57c74018cf57ccc8c32df6d592039c2da97e"
    sha256 cellar: :any_skip_relocation, ventura:       "34fbd16e350ec3863650e77711a81484b2caa31efa9c4c41b5e5f8621168adc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "993577d6740829a032040442554b0384ffc98c329ab200dbd4636006a802c8d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "566c292b08c5a4581d849e5d81654c5571831aa03c5412a150a3aa953e591c01"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-33
  disable! date: "2026-06-28", because: :deprecated_upstream

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
