class Descope < Formula
  desc "Command-line utility for performing common tasks on Descope projects"
  homepage "https://www.descope.com"
  url "https://github.com/descope/descopecli/archive/refs/tags/v0.8.7.tar.gz"
  sha256 "25c1b805aae8100a1f9763f16a25fcbbc9449fe32534d356b58f88e17b305fe4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2412e9855a1d9bd924bef71e7a88874c32d991f6b6cc307a38b74de973885b37"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "303ec8857adde4d3b8d2808b33240a24921b791a80072a7735b4b2aacbe11c98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0b6df3e76e103514726c412e3cd7c26f0e1b31b2c5d9c548b9512678b934991"
    sha256 cellar: :any_skip_relocation, sonoma:         "855243a3c9f38686b20ffea48c1d802a99aca874391be9aa91337682a39f7611"
    sha256 cellar: :any_skip_relocation, ventura:        "82d0273d03d68b15d482dbe4349f70aee1c84baf591f756be9ab99302414412d"
    sha256 cellar: :any_skip_relocation, monterey:       "8e4ff9dddd2b0a6bf640c7d63d057f21cbc39c070401e312713367bcea7a8dc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "554b09b0b832dc6bacdab3e4001bce03312b7cef3da7f223e603f45d5fa659f9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"descope", "completion")
  end

  test do
    assert_match "working with audit logs", shell_output("#{bin}/descope audit")
    assert_match "managing projects", shell_output("#{bin}/descope project")
    assert_match version.to_s, shell_output("#{bin}/descope --version")
  end
end
