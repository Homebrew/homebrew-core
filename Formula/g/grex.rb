class Grex < Formula
  desc "Command-line tool for generating regular expressions"
  homepage "https://github.com/pemistahl/grex"
  url "https://github.com/pemistahl/grex/archive/v1.4.2.tar.gz"
  sha256 "bdf8476433be13d2307fc2829cd68b15f71391f537adfc6d90d04092573d7bc4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca449c20202e83a85b4dabf23c499b09312099dedbe8800eb3f272d8c8589fe3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff9ee16e6ad69a5f6daacc00be72d0c38d2709a3dc5ad0d4b8c4022407492c91"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67957a017ab461f469b5dcf66ff38ff9dc913bd933e461acbe016e97a7e80915"
    sha256 cellar: :any_skip_relocation, ventura:        "cf9477e7d94edc47295178fc7df625d33696269ad835a272eb8fce9582e4be0c"
    sha256 cellar: :any_skip_relocation, monterey:       "b8b146b8be16cf1366cee3e2f531e6db078d2eb0872bcf9c6f390e98c2de723d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b363a6d2bf28124e8b98d3b5556957b71c7af5e9e4dfd39aded5f01a839c3b39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d73168a364e0b758b216696a7f6b529df9df4961fec7eca84a28686921a10c42"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/grex a b c")
    assert_match "^[a-c]$\n", output
  end
end
