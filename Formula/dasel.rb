class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v2.0.2.tar.gz"
  sha256 "cdb209c838b0f24520f35997c2856efbbdf695c314bc43ddcc3dc5180e8b812b"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "109b5b95230947686b6d254f4051c3f49ed404caf22a6dccd76be553526aaff3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "967fa999f2889627a0e6bf72a1590dd224f8dbb33bb94f9f5251bb6eab7cdfe9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b8a8e893ee0530822b38cd00549b30d1986f0ff03ee3a3747742a3401d4e727"
    sha256 cellar: :any_skip_relocation, ventura:        "de86fe7c11b1042af26c1be0943074f69976a36d0739d742a135d9fc3609711b"
    sha256 cellar: :any_skip_relocation, monterey:       "dfc9aa89159382bd8bad5880e3443632b444e351da24eed602b6992889e5d8c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "81641b92325f5a287646fc4164a7d9b311c9b405a4a51b89de9f1e996ea882e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "563f554a0cb1c748c93212b5f5c99d57e47fe24e513ccac4b07aefa145646e1f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X 'github.com/tomwright/dasel/internal.Version=#{version}'"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/dasel"

    generate_completions_from_executable(bin/"dasel", "completion")
  end

  test do
    assert_equal "\"Tom\"", shell_output("echo '{\"name\": \"Tom\"}' | #{bin}/dasel -r json 'name'").chomp
    assert_match version.to_s, shell_output("#{bin}/dasel --version")
  end
end
