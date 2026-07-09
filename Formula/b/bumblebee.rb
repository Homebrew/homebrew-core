class Bumblebee < Formula
  desc "Read-only developer endpoint scanner for supply-chain exposure"
  homepage "https://github.com/perplexityai/bumblebee"
  url "https://github.com/perplexityai/bumblebee/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "6ed6c27ae6b5c040eb018e247c09e53baa2fdea43bba1c3e63515d14d46157d2"
  license "Apache-2.0"
  head "https://github.com/perplexityai/bumblebee.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6dbfe7e8d0492c91365a14e8431707c6ddbb75dd83b465087981cd13a018958a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6dbfe7e8d0492c91365a14e8431707c6ddbb75dd83b465087981cd13a018958a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6dbfe7e8d0492c91365a14e8431707c6ddbb75dd83b465087981cd13a018958a"
    sha256 cellar: :any_skip_relocation, sonoma:        "70dc47858de6093e94ef9d4ca23753564c392db18da1db57c1e023e933e06952"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebcfb6442909c462f37b22ac723e24c2c141a6463c285587194595851fa00811"
    sha256 cellar: :any,                 x86_64_linux:  "a9e7b989b1259e38fc8601f043ccf43b35c7de756d3dfa86176220179ed47e71"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/bumblebee"
    pkgshare.install "threat_intel"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bumblebee version")
    assert_match "selftest OK", shell_output("#{bin}/bumblebee selftest")
  end
end
