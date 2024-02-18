class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.31.9",
      revision: "f2f4077b592dcbb4162cbfe07bd99546d47d9955"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e454f07e37c92b5618f97deb1ea2fcd1c9c9339641b58a85560c3b34336ad64"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4001d9ba9a3088dad323d318236180e521be97490af574c8073c27b8f2cb3df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5efc8b847b8469fcb9d70464a2dc17490f4ab50156c8d5f598949a34cad5ce08"
    sha256 cellar: :any_skip_relocation, sonoma:         "faf398a2a654cddc640536e503dea84b9500eb3b2cd445586718d6991517d60d"
    sha256 cellar: :any_skip_relocation, ventura:        "f4528a68e5d421f34f9081c1d4417577b9c6caeae170f9c8f99cb55bf5c70f8f"
    sha256 cellar: :any_skip_relocation, monterey:       "d16052f484b8c087c00937bad0d268365e0ca8bf8f4f0e116bff8ed645f6df3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fde7b9ea4b5cff262bcc4d51679349f5f5cb81190b754dfa84fdec2a69605b95"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/k9s/cmd.version=#{version}
      -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"k9s", "completion")
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
