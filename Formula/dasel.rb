class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v1.15.0.tar.gz"
  sha256 "278a0f92bf76bb2fe0a423aeeb105dbfb7e014d6611ecf882c93a058ed134756"
  license "MIT"
  head "https://github.com/TomWright/dasel.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c55a87da42e4be8748a80d2a0e8d68f1271afa3644ae76afd0ba72a1738a3462"
    sha256 cellar: :any_skip_relocation, big_sur:       "052614cb3f628662351a614211c0915135d75e28085fccb29ac209acf8f491c5"
    sha256 cellar: :any_skip_relocation, catalina:      "60b80b3589604edcbdbd19d84d392607804cc41067d7085305a054a0d0419d54"
    sha256 cellar: :any_skip_relocation, mojave:        "522d12bd141b61ad4cb6319918f9cd45476c666b7a5f398ff8d5ee4de944c099"
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
