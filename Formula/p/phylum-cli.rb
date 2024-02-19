class PhylumCli < Formula
  desc "Command-line interface for the Phylum API"
  homepage "https://www.phylum.io"
  url "https://github.com/phylum-dev/cli/archive/refs/tags/v6.1.1.tar.gz"
  sha256 "5eaf2036e2555303a9691bb591b4c99711f1e30be16a8fcfbef09184b1543e42"
  license "GPL-3.0-or-later"
  head "https://github.com/phylum-dev/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7ff0d702322d5d9341c085e660c52a5dbb7f9b7441413bd760253edc149cf2e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab5603209a00a7266830871920ad37ad55560aef02fc497d92b79b491e7e07fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e12a5c27f8b07c955e135b83e8dff1cfcac2ae1a71606f27ecf94dc0486cdc3"
    sha256 cellar: :any_skip_relocation, sonoma:         "36345591c56be16831490b1f3b9ff3dbc147d2bfa5e501c5dd8d95cc767e171d"
    sha256 cellar: :any_skip_relocation, ventura:        "422b1e929aed5e6324f05ffaf86dc53d0d6d6599ca80bd59ca21bdea215afe48"
    sha256 cellar: :any_skip_relocation, monterey:       "bcba6c3a0fd6e4e962857d30a2565c4cfaed366e2314a7a5aaf161a690d42827"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f65809aac14ed703f635ef4461af8f68629a30c93b3035ae4e9f3d0d3a6c8961"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/phylum version")

    output = shell_output("#{bin}/phylum extension")
    assert_match "No extensions are currently installed.", output
  end
end
