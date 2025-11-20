class Jqp < Formula
  desc "TUI playground to experiment and play with jq"
  homepage "https://github.com/noahgorstein/jqp"
  url "https://github.com/noahgorstein/jqp/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "c70e83975edb1c1dacb0fb067a0685e9632e21360805ade3dda03e54751e4855"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17f5afee30bb1f40cca378ee991b6ba46dd8cc95b1146765ee04985e150ab08a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17f5afee30bb1f40cca378ee991b6ba46dd8cc95b1146765ee04985e150ab08a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17f5afee30bb1f40cca378ee991b6ba46dd8cc95b1146765ee04985e150ab08a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a491c1f6699c1d793e9608d6f99c7b5042dfaca793924f09b47a4cb70fda8f1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02e04e3abd5d401e10ced7c84ebc5eab5037430f6629c3e3e60575a44be5079a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bce8f30853634cdf279db4adbfa9cf434e968be3a5c2b38b164200ba62df296"
  end

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
