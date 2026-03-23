class Jid < Formula
  desc "Json incremental digger"
  homepage "https://github.com/simeji/jid"
  url "https://github.com/simeji/jid/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "93eba44a69e570ecfe6c99c311568f446cddfe1ddd99672fc49fc0df3cbcdab7"
  license "MIT"
  head "https://github.com/simeji/jid.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1dcd12d8cde5a5fe7d1703d6314ed38824e3ca418807d8b48da5a1348e1da220"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1dcd12d8cde5a5fe7d1703d6314ed38824e3ca418807d8b48da5a1348e1da220"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1dcd12d8cde5a5fe7d1703d6314ed38824e3ca418807d8b48da5a1348e1da220"
    sha256 cellar: :any_skip_relocation, sonoma:        "e711c0afe47ada4d7c3a4bfc34c5c7a84ca9444553e0b4ffdd9f5b7a21a181b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8272d7bd8e98edc2ed04fe905d0fb326e3e539f330d58da7f6bcf3409997223f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1240084d702b5d30e7327cd56bca69aa405fb688a8ef8613ecffced0b97227cd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "cmd/jid/jid.go"
  end

  test do
    assert_match "jid version v#{version}", shell_output("#{bin}/jid --version")
  end
end
