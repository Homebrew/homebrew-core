class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v1.13.3.tar.gz"
  sha256 "0e57c8ef0bf8a2be05a2a84c5c46d1e349f2b22d7909149a93ecc27a9eb4b52b"
  license "MIT"
  head "https://github.com/TomWright/dasel.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fd814f30a8a33d2b8b71f57f771be4f2762573f7b153c05dac50d7cf809d116e"
    sha256 cellar: :any_skip_relocation, big_sur:       "b6a70285d6831e16c056e41ae1cad24a3572005805d79f28f349ad1dc8dc3f3f"
    sha256 cellar: :any_skip_relocation, catalina:      "aa337624aec3e65aa38b2070a98e4b595c2d4a07b1901f0dd05903fcd1fee41d"
    sha256 cellar: :any_skip_relocation, mojave:        "9df1d479029d060f037638207195e2ba648503bb4d8025c9f1275be75b8771b7"
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
