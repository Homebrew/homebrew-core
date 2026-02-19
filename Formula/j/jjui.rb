class Jjui < Formula
  desc "TUI for interacting with the Jujutsu version control system"
  homepage "https://github.com/idursun/jjui"
  url "https://github.com/idursun/jjui/archive/refs/tags/v0.9.12.tar.gz"
  sha256 "214a7f620e035bdcdfe0f9f8ac56b532bcd11a91bb7b06c515b8bf005af03ebd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f23b326270667d228b1fe675224ac893651cf354753b415556535e23b0196df6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f23b326270667d228b1fe675224ac893651cf354753b415556535e23b0196df6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f23b326270667d228b1fe675224ac893651cf354753b415556535e23b0196df6"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd2446b1a9ff6a20fc6ed6794f1ba291d87c53f3cffad3a8280416142436f5f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b64b931c97a2d1ad8a977fa85da05cda8627c68f09138c808fce943f8e89e306"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e315e2b4ec08cfd18e87626acb140beb9d0485d2d26cd4f5dbb9f196196d9663"
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
