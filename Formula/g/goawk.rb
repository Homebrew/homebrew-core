class Goawk < Formula
  desc "POSIX-compliant AWK interpreter written in Go"
  homepage "https://benhoyt.com/writings/goawk/"
  url "https://github.com/benhoyt/goawk/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "91bf708ad6776bea7e1fbd1a0969042de8ebc3139b89468a2a1f5405f3401f54"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41d62570a7ca8e9baf60b37144c32cc5d688c4a19db05e3e24bcc042c5cc5d9d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41d62570a7ca8e9baf60b37144c32cc5d688c4a19db05e3e24bcc042c5cc5d9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "41d62570a7ca8e9baf60b37144c32cc5d688c4a19db05e3e24bcc042c5cc5d9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "56b903099e0f4beb099ecaeace1ffc43873939be0357c4a15738cbb3d9353338"
    sha256 cellar: :any_skip_relocation, ventura:       "56b903099e0f4beb099ecaeace1ffc43873939be0357c4a15738cbb3d9353338"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf9199a6f2e304f9d4ac65fefe42e858272f35679f29f6a72b58fd0d22ce550c"
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
