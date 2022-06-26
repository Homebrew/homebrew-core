class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v1.25.0.tar.gz"
  sha256 "49f7a34b31c87d27ef5c5a32b87a603ac6d7d4d1a52533942676429b747e1f7e"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3209bc7e6ac32b5ef767b6b7f4ae961f4c3c5dec60230d5f606bc332a48c0be5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76c8a2470a82485705f18bdc75aa30466c9eec3f77fb86ae6618ab9c8de18126"
    sha256 cellar: :any_skip_relocation, monterey:       "ccd8b02b9dd2a695b05e047ec03dffc1df4d35dfc185f2c2cc6b05744e6eec58"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f542cc5e063d01b5673d6265a0f99abf455a165f8e2d533799b53edb9b9bc5a"
    sha256 cellar: :any_skip_relocation, catalina:       "b275412822dd45d3efac2f90f88f4309c9f89b6f7a13f9eb864319c6f08dae3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69d30163cf4b4e1360d67d768bc5d5b2a475b43998e044fe9d1f3f1639482e7a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X 'github.com/tomwright/dasel/internal.Version=#{version}'"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/dasel"
  end

  test do
    json = "[{\"name\": \"Tom\"}, {\"name\": \"Jim\"}]"
    assert_equal "Tom\nJim", pipe_output("#{bin}/dasel --plain -p json -m '.[*].name'", json).chomp
  end
end
