class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v1.13.0.tar.gz"
  sha256 "fa58488fb308a8219be61e37b0e2e670c361311469012a3d6471a2bea4392870"
  license "MIT"
  head "https://github.com/TomWright/dasel.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "46bfae22c606ad45196fd3e98325db23031254c56c33ff46fa7b16f4f18f7fe1"
    sha256 cellar: :any_skip_relocation, big_sur:       "a03dff2bdd58940d4530bbb2a61f50a4b1db3d22cb1a1540090f18766d72ac34"
    sha256 cellar: :any_skip_relocation, catalina:      "852a2b5047b5094a3da3cc5d9b370155801b05d5ed40938c11449d73f059757c"
    sha256 cellar: :any_skip_relocation, mojave:        "2b3982f53f5c16e16356b3c5ce023e2e75d2ab8261281901b0891034cbc7dae6"
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
