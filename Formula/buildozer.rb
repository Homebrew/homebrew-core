class Buildozer < Formula
  desc "Rewrite bazel BUILD files using standard commands"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools.git",
    :tag      => "3.3.0",
    :revision => "ce0cf814cb03dddf546ea92b3d6bafddb0b9eaf8"
  head "https://github.com/bazelbuild/buildtools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "394ee9a737ae1961fc4a9b64077b34ebbf62ed61466b0445a859e3277b9d3b43" => :catalina
    sha256 "394ee9a737ae1961fc4a9b64077b34ebbf62ed61466b0445a859e3277b9d3b43" => :mojave
    sha256 "394ee9a737ae1961fc4a9b64077b34ebbf62ed61466b0445a859e3277b9d3b43" => :high_sierra
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
