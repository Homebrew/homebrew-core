class KubernetesCliAT135 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.35.4",
      revision: "7b8c6cf0edd376b3d7c2f255142977c7f93db258"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.35(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba10e3e755183db3a03660bd8a2ef7ef128a2fc1553fa2608a8fa8d24aed5b36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31a8007103bd7fe52919e061024359f8431e5f2e7cda525a7d7fddbc9521fdfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80b6745e42514ce461031737b03c5e68ba83a315972ac660276d028c4f8c9e2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f283471aaa9a1731ae893ee7e55ad558c72a61741b56eb72bc719bc034f768d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4215d88b527dcb2b486965762977fc055a841feb0f0f3271cf2e387df6929cc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bb5d718ce27e468f928cc6eb92da256f546704f2ccef79a350f9eb4feb67515"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-35
  disable! date: "2027-02-28", because: :deprecated_upstream

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
