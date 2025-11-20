class Jjui < Formula
  desc "TUI for interacting with the Jujutsu version control system"
  homepage "https://github.com/idursun/jjui"
  url "https://github.com/idursun/jjui/archive/refs/tags/v0.9.5.tar.gz"
  sha256 "d2ce49499512f7d2f830c2d425d858835e8cc58a68f97af018e05ae0e6a26fca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74576c42896b756fca4da99f6349130e60f3b5b171c1ac46efebbb828e3c66ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74576c42896b756fca4da99f6349130e60f3b5b171c1ac46efebbb828e3c66ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74576c42896b756fca4da99f6349130e60f3b5b171c1ac46efebbb828e3c66ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7118e92ef5c4b19d041b626e39a04108e35809fe9d225a7dfef0a4750f3bcbb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "879b794f866666b3f44208b89e456ad8bbb3cafa116e8bf16659ec32f139b077"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5aacb160db1247b36d399d5ecfe7cd0d52b6d44f961c7d51c6b47235e53b277"
  end

  depends_on "go" => :build
  depends_on "jj"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/jjui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jjui -version")
    assert_match "Error: There is no jj repo in", shell_output("#{bin}/jjui 2>&1", 1)
  end
end
