class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/refs/tags/v0.56.0.tar.gz"
  sha256 "8785a17f52549640d1bacab66bec3156b9208c46390bb597002eeb3734085a00"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "374c4b232f286a7794908d3a61693a5ad0d64264933b84782fab67ab806687ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "374c4b232f286a7794908d3a61693a5ad0d64264933b84782fab67ab806687ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "374c4b232f286a7794908d3a61693a5ad0d64264933b84782fab67ab806687ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "441c3d24d932db223e150d71975aa2021118da78824729eb25036e85aa9e9e8e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d481d650e96a3c5cb52b01af8dbb61161c2d3fb7b9cdc8f4db735f1fd3042f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a093f64764c10c8208f33b2cd88f745dd4c1cf6d97e70f4249bbcc8eb5d24ba3"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = "-s -w -X main.version=#{version} -X main.buildSource=#{tap.user}"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
  end

  test do
    system "git", "init", "--initial-branch=main"

    output = shell_output("#{bin}/lazygit log 2>&1", 1)
    assert_match "errors.errorString terminal not cursor addressable", output

    assert_match version.to_s, shell_output("#{bin}/lazygit -v")
  end
end
