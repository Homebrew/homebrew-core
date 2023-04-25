class Buildozer < Formula
  desc "Rewrite bazel BUILD files using standard commands"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/6.1.0.tar.gz"
  sha256 "a75c337f4d046e560298f52ae95add73b9b933e4d6fb01ed86d57313e53b68e6"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00afddc6ac594220ec615a8a6f0a56f6ab5a0403593898ede63abc540fae6424"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00afddc6ac594220ec615a8a6f0a56f6ab5a0403593898ede63abc540fae6424"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00afddc6ac594220ec615a8a6f0a56f6ab5a0403593898ede63abc540fae6424"
    sha256 cellar: :any_skip_relocation, ventura:        "19c85357aa80b0ece447d5852d664434e3812c68d3cd49763e353e439e053188"
    sha256 cellar: :any_skip_relocation, monterey:       "19c85357aa80b0ece447d5852d664434e3812c68d3cd49763e353e439e053188"
    sha256 cellar: :any_skip_relocation, big_sur:        "19c85357aa80b0ece447d5852d664434e3812c68d3cd49763e353e439e053188"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "907ef4725cae0691b08674323fe6a2d6464421d51e0754f7ff3aa10ed3a26e26"
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
