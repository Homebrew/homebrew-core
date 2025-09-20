class Jqp < Formula
  desc "TUI playground to experiment and play with jq"
  homepage "https://github.com/noahgorstein/jqp"
  url "https://github.com/noahgorstein/jqp/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "e88b32aeb21b8d000e17619f23a0c00a1eb86219112204031f63fb7cdfafacf0"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jqp --version")

    # Fails in Linux CI with `open /dev/tty: no such device or address`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "Error: please provide an input file", shell_output("#{bin}/jqp 2>&1", 1)
  end
end
