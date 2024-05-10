class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.30.0",
      revision: "7c48c2bd72b9bf5c44d21d7338cc7bea77d0ad2a"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "814cc8afddfeecf6711bab4909effceae88ad789e35685e5432cd3b9ba06b079"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc5d9c0bab611f9b6f24ec3466ecf11e7d4f24f6504be59cdc592276d7d2ae18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abb10e111bc66853371ea7ffe1bf9a77cab52809166dd68ef548e273b0f1bc1c"
    sha256 cellar: :any_skip_relocation, sonoma:         "9fbbd04741ba405fd4fe1ea0ba2687ba085369fed84d4b239540385413fb2e45"
    sha256 cellar: :any_skip_relocation, ventura:        "cca7cab91f35655fdc1b17f1a6d0688088a1ddd9a73d69c796fade335d7f4ad1"
    sha256 cellar: :any_skip_relocation, monterey:       "7f5f305a25552637e43079190d26e552b34ba3896a1c17864dc45564ad5e9108"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ef901a5228ee6c20db0c97a46936baf09174bfff220b27a8e534963fb7f1228"
  end

  depends_on "bash" => :build
  depends_on "coreutils" => :build
  depends_on "go" => :build

  uses_from_macos "rsync" => :build

  def install
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
