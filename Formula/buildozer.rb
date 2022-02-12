class Buildozer < Formula
  desc "Rewrite bazel BUILD files using standard commands"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/5.0.1.tar.gz"
  sha256 "7f43df3cca7bb4ea443b4159edd7a204c8d771890a69a50a190dc9543760ca21"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da914b7dd7abae2efb9ec9e65d4aa9fff355df31790f4768cc4751899545e585"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da914b7dd7abae2efb9ec9e65d4aa9fff355df31790f4768cc4751899545e585"
    sha256 cellar: :any_skip_relocation, monterey:       "a04b9e99a5420450a02f304a2d0562fc7583edd11439dc2fad59f1bca359b387"
    sha256 cellar: :any_skip_relocation, big_sur:        "a04b9e99a5420450a02f304a2d0562fc7583edd11439dc2fad59f1bca359b387"
    sha256 cellar: :any_skip_relocation, catalina:       "a04b9e99a5420450a02f304a2d0562fc7583edd11439dc2fad59f1bca359b387"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22b749e3831ffd4d9160cfa76b5b18d66f30fea581bb11ce418d2dbb08d2ac56"
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
