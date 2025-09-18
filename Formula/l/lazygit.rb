class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/refs/tags/v0.55.1.tar.gz"
  sha256 "6c11d02c61767aea1b3f2956797f9b4b3fccc526668a3f211d4e6071195ceb2c"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc5d45a5730b8188ca903e1a5205ad6ebf8a1b3dc384dda69cd24f37893ea480"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc5d45a5730b8188ca903e1a5205ad6ebf8a1b3dc384dda69cd24f37893ea480"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc5d45a5730b8188ca903e1a5205ad6ebf8a1b3dc384dda69cd24f37893ea480"
    sha256 cellar: :any_skip_relocation, sonoma:        "b72c5e1112d81b3d3f36d3a48ba33339e8c71ee004a5091fdc17e34ddf2b3ac4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e8bce82cb9edfaaccd52d2624b8c9ff175d9abcc5de7a1789f72a1dd98439d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b668acd9e18520a5e4c701ef65c6d5447783d73228df85d82cf13229f460b4a7"
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
