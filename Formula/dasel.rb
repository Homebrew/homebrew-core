class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v1.14.0.tar.gz"
  sha256 "b12f2a6d680d63a54b736c308ca4b040f57dd4b1bc9b0a0e75fe0f32de3b5847"
  license "MIT"
  head "https://github.com/TomWright/dasel.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "28d3798b5889a79cce6ff8163d0b4ed44807d526d6d40cf7dfccb3018ac5280b"
    sha256 cellar: :any_skip_relocation, big_sur:       "44cd2b36191489e859f2fd37afd5c204ae903230d067cb79189a0b09d7b82044"
    sha256 cellar: :any_skip_relocation, catalina:      "7146ae0ca3fbc3b8ab1b6caa7144056627a5ffed43264e813924f7e0f4943881"
    sha256 cellar: :any_skip_relocation, mojave:        "3dd463e7c21fa1d19fc0cdea8cbe112d93dd9b50555178417abbc4ee56716953"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X 'github.com/tomwright/dasel/internal.Version=#{version}'"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/dasel"
  end

  test do
    json = "[{\"name\": \"Tom\"}, {\"name\": \"Jim\"}]"
    assert_equal "Tom\nJim", pipe_output("#{bin}/dasel --plain -p json -m '.[*].name'", json).chomp
  end
end
