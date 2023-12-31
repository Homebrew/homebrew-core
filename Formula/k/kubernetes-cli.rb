class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.29.0",
      revision: "3f7a50f38688eb332e2a1b013678c6435d539ae6"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "342175c8b97a09220054b936e0b06bcba56871d8291f90c9e4564bdabad72104"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2900368303076b6792520840a6b447b609b639f22016548d467a8f142fa9e34b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d54f5201ae09afdc66c90d745dbffb71e002f2dfc2f4de5adb4c121ba7a7c470"
    sha256 cellar: :any_skip_relocation, sonoma:         "7a97c56ca3f20f143a74bb64d3f6715e1700f2af28b771f150f2a08591ba550b"
    sha256 cellar: :any_skip_relocation, ventura:        "5315585c6daf76599709927c7d2e11fe3135c9863adeb0fa02481c14b6ca1218"
    sha256 cellar: :any_skip_relocation, monterey:       "2af933282563dd092bbafa70e0edcc9abcea168a46e2bfa5eacb74e57e4d236b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fba10c62bc80131fa4eef13a380d870a6355c37eeaae9be40b3e8583f57be09"
  end

  depends_on "bash" => :build
  depends_on "coreutils" => :build
  depends_on "go" => :build

  uses_from_macos "rsync" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"

    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin" # needs GNU date
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
    if build.stable?
      revision = stable.specs[:revision]
      assert_match revision.to_s, version_output
    end
  end
end
