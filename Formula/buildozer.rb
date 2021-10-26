class Buildozer < Formula
  desc "Rewrite bazel BUILD files using standard commands"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/4.2.3.tar.gz"
  sha256 "614c84128ddb86aab4e1f25ba2e027d32fd5c6da302ae30685b9d7973b13da1b"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc0bb2842071d62eb51c686f2a44e999529577469459ddbe7da00b854ea91add"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d76fd8b4a443568bf18fec9f85303d4ee7470cdd1c90fa8ad6febdfaba4292cd"
    sha256 cellar: :any_skip_relocation, monterey:       "605cb9341035054b51c201a5f85a47db436f1f1d562438f4e48b720e95b6c52d"
    sha256 cellar: :any_skip_relocation, big_sur:        "0585a97c2d8d5fbaf4bc3624eb22919a16bfeef57aa43334018b1836957c57c1"
    sha256 cellar: :any_skip_relocation, catalina:       "0585a97c2d8d5fbaf4bc3624eb22919a16bfeef57aa43334018b1836957c57c1"
    sha256 cellar: :any_skip_relocation, mojave:         "0585a97c2d8d5fbaf4bc3624eb22919a16bfeef57aa43334018b1836957c57c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dff236fa8e385dc4b54a678bb883b4a540fb32777e74638e4f439afac07418ee"
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
