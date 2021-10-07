class Buildozer < Formula
  desc "Rewrite bazel BUILD files using standard commands"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/4.2.2.tar.gz"
  sha256 "ae34c344514e08c23e90da0e2d6cb700fcd28e80c02e23e4d5715dddcb42f7b3"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "40db542ce34379d25c83a7baff75d87aa4f953646605cf4812c0c83e30c0105d"
    sha256 cellar: :any_skip_relocation, big_sur:       "9b5c3912596e4518555351c5f5675a15bbf5c0fa12682c17cc1850afea5e6b22"
    sha256 cellar: :any_skip_relocation, catalina:      "9b5c3912596e4518555351c5f5675a15bbf5c0fa12682c17cc1850afea5e6b22"
    sha256 cellar: :any_skip_relocation, mojave:        "9b5c3912596e4518555351c5f5675a15bbf5c0fa12682c17cc1850afea5e6b22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf14c4de5e3ac6e2f1cd44ecd8c9c3eb9b25b1e5a99cbc4feea75ca4c8effb1f"
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
