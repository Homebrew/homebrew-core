class Goawk < Formula
  desc "POSIX-compliant AWK interpreter written in Go"
  homepage "https://benhoyt.com/writings/goawk/"
  url "https://github.com/benhoyt/goawk/archive/refs/tags/v1.26.0.tar.gz"
  sha256 "d1618e454e01f83ec9ee553f8955a805417bb49bb1449059d4f1cd037556b4ff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "493f9965d1803a4f8a72d5ce0284c80b62ebdb0ac8bc5972614d1515e93d93d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "493f9965d1803a4f8a72d5ce0284c80b62ebdb0ac8bc5972614d1515e93d93d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "493f9965d1803a4f8a72d5ce0284c80b62ebdb0ac8bc5972614d1515e93d93d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "10c8d82a6c0f63983ee9d5d25eb5567c53114fff9901da0b8b2bd7b29bfdf4f0"
    sha256 cellar: :any_skip_relocation, ventura:        "10c8d82a6c0f63983ee9d5d25eb5567c53114fff9901da0b8b2bd7b29bfdf4f0"
    sha256 cellar: :any_skip_relocation, monterey:       "10c8d82a6c0f63983ee9d5d25eb5567c53114fff9901da0b8b2bd7b29bfdf4f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73d63e648a8ec5efc86ada3a2b0744f021f01800d00aac5ee81fcfdddef54209"
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
