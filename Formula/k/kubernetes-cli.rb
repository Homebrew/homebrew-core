class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.31.0",
      revision: "9edcffcde5595e8a5b1a35f88c421764e575afce"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e2a7ca39d5c002cbc7903da92830f50cc2615536160ab9d7e688cab78aa80704"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d41dbfeea52fc3234aabeb78d964fdb68d8563a36eab5b2bfbc0681cd487a6ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "100cff288ef4369a53d808efe06e2d084e9b9bc85c98db554c9842df54322662"
    sha256 cellar: :any_skip_relocation, sonoma:         "460efa2dd5d14aa5731b000dd8afb861f7379ad81518d5b1ff7b625eeac24a35"
    sha256 cellar: :any_skip_relocation, ventura:        "48b8f8a40a3a47420402014c45f10405f380b0c896bc301f3dcd8a88dc1d815e"
    sha256 cellar: :any_skip_relocation, monterey:       "07b70e3be18fa103d495a14a1097121a45ceb8852b7140c7c666f7b4b10ebd3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c125853b863e89cfd9777a5613dfc4bfbda76322a84ab1a08d7f6a76da76e89f"
  end

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
