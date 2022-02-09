class Buildozer < Formula
  desc "Rewrite bazel BUILD files using standard commands"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/5.0.0.tar.gz"
  sha256 "09a94213ea0d4a844e991374511fb0d44650e9c321799ec5d5dd28b250d82ca3"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf4268b5d38efa4af65b44f586d3906a29bb9ff9ba1321535c32843057cd3181"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf4268b5d38efa4af65b44f586d3906a29bb9ff9ba1321535c32843057cd3181"
    sha256 cellar: :any_skip_relocation, monterey:       "c607c6785286eef28c42c4e029c74a38fe6e80e54fb7c38e6f86cf6d1628c090"
    sha256 cellar: :any_skip_relocation, big_sur:        "c607c6785286eef28c42c4e029c74a38fe6e80e54fb7c38e6f86cf6d1628c090"
    sha256 cellar: :any_skip_relocation, catalina:       "c607c6785286eef28c42c4e029c74a38fe6e80e54fb7c38e6f86cf6d1628c090"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb20066c61284e699bc01c29223e1d52d15dcca3819d94e2733d28f26e8dede7"
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
