class Buildozer < Formula
  desc "Rewrite bazel BUILD files using standard commands"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/4.2.5.tar.gz"
  sha256 "d368c47bbfc055010f118efb2962987475418737e901f7782d2a966d1dc80296"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46be299ff467f04a94f0287256588174564f058dbbb87e134d681e97181ac334"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46be299ff467f04a94f0287256588174564f058dbbb87e134d681e97181ac334"
    sha256 cellar: :any_skip_relocation, monterey:       "c5575769231c3a8190634501cd7f1d2c998b31bc892483f73dae1cd45f664353"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5575769231c3a8190634501cd7f1d2c998b31bc892483f73dae1cd45f664353"
    sha256 cellar: :any_skip_relocation, catalina:       "c5575769231c3a8190634501cd7f1d2c998b31bc892483f73dae1cd45f664353"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10a6abd98632c8ecd806f7cda7b2509b422ae1079f9494020448e85b4473f6e6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./buildozer"
  end

  test do
    build_file = testpath/"BUILD"

    touch build_file
    system "#{bin}/buildozer", "new java_library brewed", "//:__pkg__"

    assert_equal "java_library(name = \"brewed\")\n", build_file.read
  end
end
