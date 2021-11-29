class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://github.com/go-delve/delve/archive/v1.7.3.tar.gz"
  sha256 "961642eb4cd97e11093dda81273971a45e64abb2fe7db39165072c7145f4fcec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "344c9c5af1215e7d57657a27b91aeaf87fd84ebfa5eb25cd551d77f51a1f53ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a8c509ddd8e5738c8dcea0b1c9cf781788be59e863ca78293bbcb057a85e77a"
    sha256 cellar: :any_skip_relocation, monterey:       "7771bed18dce5d8fed2c1d27408f248a9d4de6e1767ad4f9c2459d401680bf18"
    sha256 cellar: :any_skip_relocation, big_sur:        "255034c5727b5abead6d84089e9aa19e0b1e25cce1935898b366250196f4f8c1"
    sha256 cellar: :any_skip_relocation, catalina:       "ec0e38cedf3fc0cf04753700cd4916412dff4a8c7c11adda2ff255cfef16f9e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "233be0622385b6ecba034413b538b6df62a79c71b720d10a433b9b2126b4580f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"dlv"), "./cmd/dlv"
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end
