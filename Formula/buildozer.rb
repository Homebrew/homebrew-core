class Buildozer < Formula
  desc "Rewrite bazel BUILD files using standard commands"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/5.0.0.tar.gz"
  sha256 "09a94213ea0d4a844e991374511fb0d44650e9c321799ec5d5dd28b250d82ca3"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb71df0b3f97a73b177d29ea25cfe0ad120a45a7a55d567903be3252c7a9022b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb71df0b3f97a73b177d29ea25cfe0ad120a45a7a55d567903be3252c7a9022b"
    sha256 cellar: :any_skip_relocation, monterey:       "a756f1ed4b2b16994beecb07070438eda196dd9218e4e0e59726bfc0e78b56d2"
    sha256 cellar: :any_skip_relocation, big_sur:        "a756f1ed4b2b16994beecb07070438eda196dd9218e4e0e59726bfc0e78b56d2"
    sha256 cellar: :any_skip_relocation, catalina:       "a756f1ed4b2b16994beecb07070438eda196dd9218e4e0e59726bfc0e78b56d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2383f99d1430d7d83714f81ad78772c8d80e213cc213c2680143601aa4f1fd8f"
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
