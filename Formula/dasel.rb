class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v1.16.1.tar.gz"
  sha256 "5c70d4aaa087031b158c59c9c17bad0a96caad387e0117e5040b6fd9b15b582c"
  license "MIT"
  head "https://github.com/TomWright/dasel.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "89aff2759696fad15936767a7e588c304a1dbe8582388b2525fe809de2f7d074"
    sha256 cellar: :any_skip_relocation, big_sur:       "f507fd2a396cb489e54b904b719ca05dcba0e8a199eda411a732aecff407c2ed"
    sha256 cellar: :any_skip_relocation, catalina:      "da6eb4609a572b33f6147e616a5a1f65f1ed22bb2a6cb4ee22d1f24b7de1ae09"
    sha256 cellar: :any_skip_relocation, mojave:        "a04c05d640624c4b46542ef3f313c73ed08894287a8dc353185e97af8c3ce883"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cb597ff0f91895b0a231db684309b4d607677be1c13b44a426a85ba3737e1aa"
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
