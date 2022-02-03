class Goawk < Formula
  desc "POSIX-compliant AWK interpreter written in Go"
  homepage "https://benhoyt.com/writings/goawk/"
  url "https://github.com/benhoyt/goawk/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "a48d3b21f0eb84b4832cc6ba63edc9e4e4e5b952b37b213d69d52e80e7f16934"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5bba82a1d9a74add3564dfabfd7ed55ebbe39c5f4952a4d23035541c1b5971c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5bba82a1d9a74add3564dfabfd7ed55ebbe39c5f4952a4d23035541c1b5971c"
    sha256 cellar: :any_skip_relocation, monterey:       "f825a1332cec02026a5fb18bc7c35219061bdc4a7082b113bbf8a352ae70bba1"
    sha256 cellar: :any_skip_relocation, big_sur:        "f825a1332cec02026a5fb18bc7c35219061bdc4a7082b113bbf8a352ae70bba1"
    sha256 cellar: :any_skip_relocation, catalina:       "f825a1332cec02026a5fb18bc7c35219061bdc4a7082b113bbf8a352ae70bba1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b751aedbd3f63942c157b527203acf26c4113cfc13ebaff815e69c1c2099c720"
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
