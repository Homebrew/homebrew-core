class Mactop < Formula
  desc "Apple Silicon Monitor Top written in Golang"
  homepage "https://github.com/context-labs/mactop"
  url "https://github.com/context-labs/mactop/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "d8cf794d321d2bb09aa9bc7d5e3b084453de796ad6b0add9d6922f1f664db840"
  license "MIT"
  head "https://github.com/context-labs/mactop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c0a933ce73ad73eda57b6af68e96cd02a0ff41132452b6b9d14ef55e72c8eac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82ea5f3e98f71f330319a56f8ab57081a8354521856daf387757072def9f6cbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4ffaa07fdf378c050cc4f2031c1686532de2a6cceebb3d006e3d63e80870ca5"
  end

  depends_on "go" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  def caveats
    <<~EOS
      mactop requires root privileges, so you will need to run `sudo mactop`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    test_input = "This is a test input for brew"
    assert_match "Test input received: #{test_input}", shell_output("#{bin}/mactop --test '#{test_input}'")
  end
end
