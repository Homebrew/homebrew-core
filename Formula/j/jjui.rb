class Jjui < Formula
  desc "TUI for interacting with the Jujutsu version control system"
  homepage "https://github.com/idursun/jjui"
  url "https://github.com/idursun/jjui/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "31cd605acc0cdacfb15ad00f5f78efaaa4f16b9aee38c13aeb532dd141f28590"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e942961088d0ee328a49a8673148da16c054a563f9404460845a7d5d1384e549"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e942961088d0ee328a49a8673148da16c054a563f9404460845a7d5d1384e549"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e942961088d0ee328a49a8673148da16c054a563f9404460845a7d5d1384e549"
    sha256 cellar: :any_skip_relocation, sonoma:        "28328e6dcf191363ed9ca04710b5890fe8cedb3e3d94bf11001f0fec66a50ef8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88efad7dcf7855d1e33c1b36a121909d17b5b7c650c8bbb62e23c612b0e40a20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "853609cf9907b36c220332693835e52c492756caa9ae1ee92fcfe36155a7c973"
  end

  depends_on "go" => :build
  depends_on "jj"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/jjui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jjui -version")
    assert_match "There is no jj repo in", shell_output("#{bin}/jjui 2>&1", 1)
  end
end
