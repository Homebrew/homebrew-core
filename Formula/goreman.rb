class Goreman < Formula
  desc "Foreman clone written in Go"
  homepage "https://github.com/mattn/goreman"
  url "https://github.com/mattn/goreman/archive/v0.3.11.tar.gz"
  sha256 "2ff6a2746f17b00fe13ae942b556f346713e743de9a0f66208d63fe2d5586063"
  license "MIT"
  head "https://github.com/mattn/goreman.git", branch: "master"

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f84399eff06321a5b182e2bf72db14cf1d16ea66de880ed28ae21d84c3049530"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "617893eee7167522eef137b451a75c58ebf61763342873c5931e8489c8048f5c"
    sha256 cellar: :any_skip_relocation, monterey:       "47ef7cb6bd2b6dd3c369699979a1a627507d80e2b55c6c591f3fd339db8bfab2"
    sha256 cellar: :any_skip_relocation, big_sur:        "3cbad1a55ba81b99570db12e9223b9be3ccacfb2064bb8811cdf63307141430b"
    sha256 cellar: :any_skip_relocation, catalina:       "ac244b86a6b0fc62a1f04d68914f303abd7a1f29ada7650643797c43720c2973"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7551327a1f817fa1778cd790ca681ea2fc46d3dcea41780158f96cf91a512cab"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"goreman"
  end

  test do
    (testpath/"Procfile").write "web: echo 'hello' > goreman-homebrew-test.out"
    system bin/"goreman", "start"
    assert_predicate testpath/"goreman-homebrew-test.out", :exist?
    assert_match "hello", (testpath/"goreman-homebrew-test.out").read
  end
end
