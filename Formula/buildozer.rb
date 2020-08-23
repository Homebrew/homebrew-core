class Buildozer < Formula
  desc "Rewrite bazel BUILD files using standard commands"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools.git",
    tag:      "3.4.0",
    revision: "b1667ff58f714d13c2bba6823d6c52214705508f"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d37c5fbccc7386681f297931fac56e086d90cfa17d7d66100005d83c790ba70" => :catalina
    sha256 "7d37c5fbccc7386681f297931fac56e086d90cfa17d7d66100005d83c790ba70" => :mojave
    sha256 "7d37c5fbccc7386681f297931fac56e086d90cfa17d7d66100005d83c790ba70" => :high_sierra
  end

  depends_on "bazelisk" => :build

  def install
    system "bazelisk", "build", "--config=release", "buildozer:buildozer"
    bin.install "bazel-bin/buildozer/darwin_amd64_stripped/buildozer"
  end

  test do
    build_file = testpath/"BUILD"

    touch build_file
    system "#{bin}/buildozer", "new java_library brewed", "//:__pkg__"

    assert_equal "java_library(name = \"brewed\")\n", build_file.read
  end
end
