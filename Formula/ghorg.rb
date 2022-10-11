class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https://github.com/gabrie30/ghorg"
  url "https://github.com/gabrie30/ghorg/archive/refs/tags/v1.8.8.tar.gz"
  sha256 "23fb03e10301df8c0481f8b5bc11e96f944e510a6cb929715f74e33450437693"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5860ca585d1a2232d629874cf7cc4697448480214897cb44fbf6d5952540f4ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a2fbd2be9e2f2ba0aebdf41e324d7dbead47fa81520bf75f6ed34459f472965"
    sha256 cellar: :any_skip_relocation, monterey:       "c028aa71ceb8f76d9f85ecad7f38592191b2d3bbb59028f3b301b1e76752ef49"
    sha256 cellar: :any_skip_relocation, big_sur:        "30f168622d659fedec467d7a11c77b89df9a9d70111dca9ac6f2c483867f2ae1"
    sha256 cellar: :any_skip_relocation, catalina:       "1042c86977dc8bb281e3e2b641992d638b279f6d293372c9d5d75477451cc62e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1492e021fff538edab2482c4eda8c375e54aacbdf659a90f76a600b46467a20"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"ghorg", "completion")
  end

  test do
    assert_match "No clones found", shell_output("#{bin}/ghorg ls")
  end
end
