class Buildozer < Formula
  desc "Rewrite bazel BUILD files using standard commands"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/4.2.2.tar.gz"
  sha256 "ae34c344514e08c23e90da0e2d6cb700fcd28e80c02e23e4d5715dddcb42f7b3"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d76fd8b4a443568bf18fec9f85303d4ee7470cdd1c90fa8ad6febdfaba4292cd"
    sha256 cellar: :any_skip_relocation, big_sur:       "0585a97c2d8d5fbaf4bc3624eb22919a16bfeef57aa43334018b1836957c57c1"
    sha256 cellar: :any_skip_relocation, catalina:      "0585a97c2d8d5fbaf4bc3624eb22919a16bfeef57aa43334018b1836957c57c1"
    sha256 cellar: :any_skip_relocation, mojave:        "0585a97c2d8d5fbaf4bc3624eb22919a16bfeef57aa43334018b1836957c57c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dff236fa8e385dc4b54a678bb883b4a540fb32777e74638e4f439afac07418ee"
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
