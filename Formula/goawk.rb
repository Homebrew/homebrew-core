class Goawk < Formula
  desc "POSIX-compliant AWK interpreter written in Go"
  homepage "https://benhoyt.com/writings/goawk/"
  url "https://github.com/benhoyt/goawk/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "43054fbe53922807d97816be802a39a9485c71369eb74f9ed2c2877dcb4d3629"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e054d0c53094286ffc3edbd3d220011577d3438a8cae9e5bf86a910829b2bc2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e054d0c53094286ffc3edbd3d220011577d3438a8cae9e5bf86a910829b2bc2"
    sha256 cellar: :any_skip_relocation, monterey:       "e884ae48a7dea0b7b12f49e9d3f47b60761452c249a79d0a01bd3473a41ec8fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "e884ae48a7dea0b7b12f49e9d3f47b60761452c249a79d0a01bd3473a41ec8fa"
    sha256 cellar: :any_skip_relocation, catalina:       "e884ae48a7dea0b7b12f49e9d3f47b60761452c249a79d0a01bd3473a41ec8fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86a53405b050e57acd602448a1000a5329343c74156d190bca624068afa2614a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = pipe_output("#{bin}/goawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end
