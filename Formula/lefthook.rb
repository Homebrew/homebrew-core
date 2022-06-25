class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "06680a58cd7c7277f745ae89624b8c43de37fb2cfe5ba32e3c6882306cff0f6c"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8aae0593bc21fe3f31a1149a841682b909a8d6c55296549db980d2bfc2a20355"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10a06556ed8487c8f754ffc50c8d16d857dfe9a54fe5d16358b5adc080e72cf9"
    sha256 cellar: :any_skip_relocation, monterey:       "aa731243a390296befa7cbc3cd2500bbc7c42b9a14b786444121e48fa6b1561b"
    sha256 cellar: :any_skip_relocation, big_sur:        "721e1eb9321c2671f04a8d860a5f8832a86bd801526ada9caf794df72b64b09f"
    sha256 cellar: :any_skip_relocation, catalina:       "19326938dc6a103a70e6d29690f8acc25f431a02ae8997268ccf9e0dd2426695"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc645449194ac8caa0a4050888fb212e1be414f2fa0d8e17f5013d10945d583e"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
