class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/5.0.0.tar.gz"
  sha256 "09a94213ea0d4a844e991374511fb0d44650e9c321799ec5d5dd28b250d82ca3"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5116f540496272980ceb3441b8848bba227235ede515da637ccc62895d7c3b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5116f540496272980ceb3441b8848bba227235ede515da637ccc62895d7c3b8"
    sha256 cellar: :any_skip_relocation, monterey:       "1788be9f53f8681770f57b4e3b04bffd224e7e705dd8d01d76ac52c2bc0a694d"
    sha256 cellar: :any_skip_relocation, big_sur:        "1788be9f53f8681770f57b4e3b04bffd224e7e705dd8d01d76ac52c2bc0a694d"
    sha256 cellar: :any_skip_relocation, catalina:       "1788be9f53f8681770f57b4e3b04bffd224e7e705dd8d01d76ac52c2bc0a694d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7cee2584b709f6ecaeb2bfdfb5147c1013d1251223edd4a1ff782c21d9363e6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./buildifier"
  end

  test do
    touch testpath/"BUILD"
    system "#{bin}/buildifier", "-mode=check", "BUILD"
  end
end
