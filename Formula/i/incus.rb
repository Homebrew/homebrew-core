class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https://linuxcontainers.org/incus"
  url "https://linuxcontainers.org/downloads/incus/incus-6.12.tar.xz"
  sha256 "c165077b150d175845199b5763643d1630e9afe9d02fa58be227a1ef00bf4abc"
  license "Apache-2.0"
  head "https://github.com/lxc/incus.git", branch: "main"

  livecheck do
    url "https://linuxcontainers.org/incus/downloads/"
    regex(/href=.*?incus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96c0e9f8b692336ee8a2b5218997bdc50d128bb37aae72633425d8c5fd18b449"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96c0e9f8b692336ee8a2b5218997bdc50d128bb37aae72633425d8c5fd18b449"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "96c0e9f8b692336ee8a2b5218997bdc50d128bb37aae72633425d8c5fd18b449"
    sha256 cellar: :any_skip_relocation, sonoma:        "b879970fef17805a567779870e95cb95134673e90deb27fe889474f0288c07cd"
    sha256 cellar: :any_skip_relocation, ventura:       "b879970fef17805a567779870e95cb95134673e90deb27fe889474f0288c07cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebaff3260b927859e23d59d8b37d3a851fc5d34872e1cdb4e064cc3b51c9d3fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fca0ec9e0434f01409bc0e8809975f2c0fab3a3e7faac74a626257ec257df88"
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
