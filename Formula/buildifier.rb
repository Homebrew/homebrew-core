class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/4.2.2.tar.gz"
  sha256 "ae34c344514e08c23e90da0e2d6cb700fcd28e80c02e23e4d5715dddcb42f7b3"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ecd732055cf0f9733d99d6564ebfb062eb060b5835e13c3c610aae02808411e9"
    sha256 cellar: :any_skip_relocation, big_sur:       "1155f17cc3bb102deccaa9e8ee5bff1a8742984d5901d809613c26e9a439123c"
    sha256 cellar: :any_skip_relocation, catalina:      "1155f17cc3bb102deccaa9e8ee5bff1a8742984d5901d809613c26e9a439123c"
    sha256 cellar: :any_skip_relocation, mojave:        "1155f17cc3bb102deccaa9e8ee5bff1a8742984d5901d809613c26e9a439123c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2de6a7ea54e77e9e349f2198009b3b6a36d5bc13dc843b2390102ba68df5fa07"
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
