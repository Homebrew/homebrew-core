class KubernetesCliAT132 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.32.12",
      revision: "39350c63df5a2a3bdd2b506bf2b166d05e5af44d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.32(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac5609084898ab30a11d8227993258ddba1dc168ac02d6b6706a1ed5197f0f8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72984c08a7f197a1fcf2ade3edad3da78b3ea076e8f83a40b7906cb950111b99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04bbf7ad6b1baecac3638224dc7e44132d38bbfbdbecedec78727bb91f15730b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c47024b443258be8f6c5207d47a84310df97219391db5aac6102914625a61bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8fc3197738a8c802ba1c4477a09c5a7738849c36ba1f919dbec5ebe0902f1f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e824e9dcb4084563482a86191b841ca1ab9b52d8397ae3e19c0ad04bc1fea4e4"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-32
  disable! date: "2026-02-28", because: :deprecated_upstream

  depends_on "go" => :build

  uses_from_macos "rsync" => :build

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
