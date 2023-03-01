class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.26.2",
      revision: "fc04e732bb3e7198d2fa44efa5457c7c6f8c0f5b"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a831de10724c6d6d449d81135e93d6df7c947f18c11c282b47de92af017311b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c204b75c3b66b4ab9ab23c5ba9a7ba4eb3dd3847b94869e38eef159b32321b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6500bfaf44af5b1b664fbb0bd17fe09032d4f548b3d348c781b8ca59c9a58f4f"
    sha256 cellar: :any_skip_relocation, ventura:        "a5da0eb1fd6434dbbfe4abe8fb442c79d4c442888e82eb9cfcc78086c9d6abe8"
    sha256 cellar: :any_skip_relocation, monterey:       "e421cee1a3cbf04cc5f7e95f1905c461a919dea708fcfe1c1fc4761eea6ddc74"
    sha256 cellar: :any_skip_relocation, big_sur:        "d243e4764a11e59a30b3422f2fa6cc215d4f4e0a15a1838c660b4160f33ddfd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69d5374efc9321dc5c312e4d434b17d9b11c05e66aec480751d2ea23ef34947e"
  end

  depends_on "bash" => :build
  depends_on "coreutils" => :build
  depends_on "go" => :build

  uses_from_macos "rsync" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"

    # Make binary
    # Deparallelize to avoid race conditions in creating symlinks, creating an error like:
    #   ln: failed to create symbolic link: File exists
    # See https://github.com/kubernetes/kubernetes/issues/106165
    ENV.deparallelize
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
