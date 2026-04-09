class KubectlRookCeph < Formula
  desc "Rook plugin for Ceph management"
  homepage "https://rook.io/"
  url "https://github.com/rook/kubectl-rook-ceph/archive/refs/tags/v0.9.6.tar.gz"
  sha256 "5e580a42f1fda40a0ec4db0af24bc09f2ec0fcb02393ffb6ba2d7b08ea5c99e2"
  license "Apache-2.0"
  head "https://github.com/rook/kubectl-rook-ceph.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e70fc098596221f6b4d0dbc2f1c1336052cbf2981a92f3a2221577b8ac281c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c5f03adfaa167f91787d63d0646f4c4f9cb9732a020f53d13d3ee143a8239e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4272be22632b74e10d0de5bc7bbb77c5f273b6e7f649cb206f41ce2e465ad29"
    sha256 cellar: :any_skip_relocation, sonoma:        "df71650b4b0ea6ce29c31f2d784995f0e9109f41f354481b73c4f17e471a1b5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "805404e5d0d91b466323291780bcea20cd0740319ab9178a58b07f136aeb2f0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3084c2e1aff1f91c9d81859903ced607f76fcad83bd43a258d8003aa28468284"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:, output: "#{bin}/kubectl-rook_ceph"), "./cmd"
  end

  test do
    assert_match <<~EOS, shell_output("#{bin}/kubectl-rook_ceph health 2>&1", 1)
      Error: invalid configuration: no configuration has been provided, \
      try setting KUBERNETES_MASTER environment variable
    EOS

    output = shell_output("#{bin}/kubectl-rook_ceph --help")
    assert_match("kubectl rook-ceph provides common management and troubleshooting tools for Ceph", output)
  end
end
