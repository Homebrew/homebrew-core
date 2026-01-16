class Csprecon < Formula
  desc "Discover new target domains using Content Security Policy"
  homepage "https://github.com/edoardottt/csprecon"
  url "https://github.com/edoardottt/csprecon/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "d86f960f21d029a5ac6e6b4087f1b1dcc7ad7632007d8646b8185d3e39fbc7d6"
  license "MIT"
  head "https://github.com/edoardottt/csprecon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f621fc56cd9c69ff6203214c6936e73109a4c86ac723d964739879ee7c014e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f621fc56cd9c69ff6203214c6936e73109a4c86ac723d964739879ee7c014e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f621fc56cd9c69ff6203214c6936e73109a4c86ac723d964739879ee7c014e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "c57841b2a41ce3cd03545bfd6ab3b1ffdd5fb887c6eb1e6b1a0ef68598d9db35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78623ece065d4f95d47da3454d2434bce1033e32043227a8335c14c5c79dcf68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be01fa962035939cc3a2f94335fc4f227fe06080725cb025a85c6234c2b2bef1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/csprecon"
  end

  test do
    output = shell_output("#{bin}/csprecon -u https://brew.sh")
    assert_match "avatars.githubusercontent.com", output
  end
end
