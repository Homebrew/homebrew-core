class KubernetesCliAT134 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.34.3",
      revision: "df11db1c0f08fab3c0baee1e5ce6efbf816af7f1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.34(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6c25edcda04151bb2044aedac8da5d7c56c5733d13d16f0e271024e30351e4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dad92248113475cd0d13739ec79e78259e8de1b2ae6e5862fba1f15fd77193a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e87f2e4d87dfb2e5871ece8902ba3fc917c055ed6f0918c29ea4b359ae6dd369"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ee9b34dd04f0309f59baf6d8097b7eddd2d304ac860b91c53337b9e6affddee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "817d0358a306c63edd79952ecb839381631a13c378e6cfffa30d2d2df22fe192"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "274e0e3b5a3a443472eb623a5d59030eacff0729725f4488517f03b2be642e97"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-34
  disable! date: "2026-10-27", because: :deprecated_upstream

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
