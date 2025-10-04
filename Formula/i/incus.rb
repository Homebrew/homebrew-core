class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https://linuxcontainers.org/incus"
  url "https://linuxcontainers.org/downloads/incus/incus-6.17.tar.xz"
  sha256 "b82397c1bd32ae0eeacb6bf34891653df8b06eb6e4dddeeac3760a24ef0544ec"
  license "Apache-2.0"
  head "https://github.com/lxc/incus.git", branch: "main"

  livecheck do
    url "https://linuxcontainers.org/incus/downloads/"
    regex(/href=.*?incus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa0c537d3b77262e9969bfe91061db66c7d1f7711b0e3c75b6f60ef000f12c8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa0c537d3b77262e9969bfe91061db66c7d1f7711b0e3c75b6f60ef000f12c8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa0c537d3b77262e9969bfe91061db66c7d1f7711b0e3c75b6f60ef000f12c8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "307e730b397b052da0d74f704173efedf4dbdb69cd3b717e66da32ac04ae7a4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f50cd1ed286da4107b450bbdb1b53676f90f24679a7ab47fa136fcb52b4a2ce4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e47b625057df73266629b94b983d4e142efbdc47bd2fdcfa49c58886106b236"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/incus"

    generate_completions_from_executable(bin/"incus", "completion")
  end

  test do
    output = JSON.parse(shell_output("#{bin}/incus remote list --format json"))
    assert_equal "https://images.linuxcontainers.org", output["images"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/incus --version")
  end
end
