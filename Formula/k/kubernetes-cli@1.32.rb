class KubernetesCliAT132 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.32.4",
      revision: "59526cd4867447956156ae3a602fcbac10a2c335"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.32(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b622184d551539afc287c7191f7f1e8213da397fd9724bd3d300371a30579b4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e07c9dc801ddf59f9123bb779e6602b994f56c8856435e7e831d9b7d29300156"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3e2260b43334e1bba161f67eb37ec7913b2ef464f05fab19199b52a968f53236"
    sha256 cellar: :any_skip_relocation, sonoma:        "fed174d3474938938cf32ab1bb69191855dc57d549da9b90569008e4a82dbcad"
    sha256 cellar: :any_skip_relocation, ventura:       "c032723a41d2e7682eb7a8bc0fcf89953efc69f2dcdc8819dbd55eeebb9f6ce5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56affb9b50d5a9711213eba78cfaacfa405d1268efebb30064c0c02dd7c214c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84168419122fef29efc6f801aaf6900fef6391a21fc232a3e73ce157a652b581"
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
