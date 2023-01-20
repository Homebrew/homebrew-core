class PowermanDockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/powerman/dockerize"
  url "https://github.com/powerman/dockerize/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "f3f801fa05e22322c09deb4603fe0cbffe41782e8c6b8923107aae5d93251785"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7391856b61235d519dd963de1752e280a1929efd6a85fdcae3fdb38f01d23d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7e0c6feca7d2a16c7d92e19dc0b98565ab13c250a28ba29e4509831d9b43377"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e80606a13537c77163eea188e6731775b8ed4920ea6a47febe2778feab494a59"
    sha256 cellar: :any_skip_relocation, ventura:        "c8ac791e7753afab462d8e34a95329c1e9d6ac059d90d1823bc4e15f910efaee"
    sha256 cellar: :any_skip_relocation, monterey:       "aa828ed546efe1a420c0ddec3f2c61f7bb87d99a486b40bf0ecc810cfac626d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "0016fbbf9de7259deec1d18512b428a77e5673c8db758fcb0242fd0050dd3f04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "302336f1c52d60c91bbf3b7a9cba145e4f20f6826c91d6f4e668a8abf42c9114"
  end

  depends_on "go" => :build
  conflicts_with "dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  def install
    system "go", "build", *std_go_args(output: bin/"dockerize", ldflags: "-s -w -X main.ver=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system "#{bin}/dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end
