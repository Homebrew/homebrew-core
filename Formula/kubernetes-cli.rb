class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.26.3",
      revision: "9e644106593f3f4aa98f8a84b23db5fa378900bd"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47789292b40da918b069f11884f022349797ef4f5b407dfcdb934fa6e8f5748d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d78b4d4e1240f9514d4a4c050cbb759495215efeb3e5d5f99d510f4eedc3ac4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5a351b74c2925796c3e34a3cc0cceec71576c4d953068707cf38de2b866e61b"
    sha256 cellar: :any_skip_relocation, ventura:        "a9a8b717267b5c21c05a0c441426be45dbbf0d0d9984b869d27f3185de1cb537"
    sha256 cellar: :any_skip_relocation, monterey:       "19b314b64b00b7b2348b147c1c9bdb9a71f90e1710256ead09115b5f1d08acfe"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf4d0c187e9aed249d3e7336461a62a43978f810e9feae00e838db1a23423a9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "522b945df7232083945de552a24fd17155703bbfcd70bc2a5a91a6aa49930e10"
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

    version_output = shell_output("#{bin}/kubectl version --client 2>&1")
    assert_match "GitTreeState:\"clean\"", version_output
    if build.stable?
      revision = stable.specs[:revision]
      assert_match revision.to_s, version_output
    end
  end
end
