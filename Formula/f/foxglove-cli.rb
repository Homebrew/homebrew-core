class FoxgloveCli < Formula
  desc "Foxglove command-line tool"
  homepage "https://github.com/foxglove/foxglove-cli"
  url "https://github.com/foxglove/foxglove-cli/archive/refs/tags/v1.0.25.tar.gz"
  sha256 "4afa3b75df51ebf935dc4e5dd91d897e62092921ebd91b87017bac2c33b95ca5"
  license "MIT"
  head "https://github.com/foxglove/foxglove-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35393da09b9ecfb2d51699ce13c4bf0fe8dd1ea18c5832ffa76a0cfc62f971ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74846ce96f9dd821202af2922939c77d1a3517df30e02acc4f970bc7b8277505"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e63a70e71823047bbafbebaaf798b3dbed012662fba3b74613b11610ca2d86b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "661f39df22bed85678f9e44bc0e02c96ceb52ded98856bb12590f37d18bf176e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d67352496b826f19d86f54769efb2da8295d0bdfeada6f92cafa5c0b9e902b1"
    sha256 cellar: :any_skip_relocation, ventura:       "41dd3172ec4599b9928dc6e78f5faf3ac5b71a97ebadef60e24a899dc7424e7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6f3ca34ea7d15ec69bb7be2106fd71abb4e3255e3d2418f186bafb8d61c1963"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "030b696eeca10813e5fe69403aa029939c56fd087508818e115d7294c1dd8a8c"
  end

  depends_on "go" => :build

  def install
    cd "foxglove" do
      system "make", "build", "VERSION=v#{version}"
      bin.install "foxglove"
    end
  end

  test do
    system bin/"foxglove", "auth", "configure-api-key", "--api-key", "foobar"
    expected = "Authenticated with API key"
    assert_match expected, shell_output("#{bin}/foxglove auth info")
    assert_match version.to_s, shell_output("#{bin}/foxglove version")
  end
end
