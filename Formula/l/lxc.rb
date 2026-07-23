class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://ubuntu.com/lxd"
  url "https://github.com/canonical/lxd/releases/download/lxd-6.9/lxd-6.9.tar.gz"
  sha256 "c13dff67aa400d3cc4ef3a20344a500fa691263132ad9de843c5485caffe47dd"
  license "AGPL-3.0-only"
  head "https://github.com/canonical/lxd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4495ea86693be3b3ac67a0be849e3d58b8fcb296d70a7f761b422a4335fb0e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4495ea86693be3b3ac67a0be849e3d58b8fcb296d70a7f761b422a4335fb0e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4495ea86693be3b3ac67a0be849e3d58b8fcb296d70a7f761b422a4335fb0e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "62dd6f409cf51a7643a0e1f3dedb29ea81e19ef91c32ef3284e1c840b0a0d2f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10ea2d97e1ae268002f154eaf3f49adf0d92958082934883a33e541f7f3e61f8"
    sha256 cellar: :any,                 x86_64_linux:  "0dd6909ebb198e505c036430d9c86c9bfc1248b06329584439059c03257ec3ff"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./lxc"

    generate_completions_from_executable(bin/"lxc", shell_parameter_format: :cobra)
  end

  test do
    output = JSON.parse(shell_output("#{bin}/lxc remote list --format json"))
    assert_equal "https://cloud-images.ubuntu.com/releases/", output["ubuntu"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/lxc --version")
  end
end
