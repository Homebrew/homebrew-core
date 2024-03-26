class Buildozer < Formula
  desc "Rewrite bazel BUILD files using standard commands"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/v7.1.0.tar.gz"
  sha256 "061472b3e8b589fb42233f0b48798d00cf9dee203bd39502bd294e6b050bc6c2"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "76cc03f586bf45019d39b37ea9fcb0ca5a405c9ec20f40b5dcbe98907bfb3b59"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76cc03f586bf45019d39b37ea9fcb0ca5a405c9ec20f40b5dcbe98907bfb3b59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76cc03f586bf45019d39b37ea9fcb0ca5a405c9ec20f40b5dcbe98907bfb3b59"
    sha256 cellar: :any_skip_relocation, sonoma:         "457a054c8869b4e72c05e39d79b579b763a460004cbfa51ab920c4e742d75153"
    sha256 cellar: :any_skip_relocation, ventura:        "457a054c8869b4e72c05e39d79b579b763a460004cbfa51ab920c4e742d75153"
    sha256 cellar: :any_skip_relocation, monterey:       "457a054c8869b4e72c05e39d79b579b763a460004cbfa51ab920c4e742d75153"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "658785181f2250bfeb5353df422a428cb4c2053e826a7d023913f30401fb18ee"
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
