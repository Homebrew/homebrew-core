class Buildozer < Formula
  desc "Rewrite bazel BUILD files using standard commands"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/v7.1.1.tar.gz"
  sha256 "60a9025072ae237f325d0e7b661e1685f34922c29883888c2d06f5789462b939"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a1a3e775849f713601b517b24567a0eff1737fe2633123c49ea2f67d005d354f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1a3e775849f713601b517b24567a0eff1737fe2633123c49ea2f67d005d354f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1a3e775849f713601b517b24567a0eff1737fe2633123c49ea2f67d005d354f"
    sha256 cellar: :any_skip_relocation, sonoma:         "b4d767e39dd77e765d7f6cf7a859f6681e00dcb564c4d5d59085aa6a75edd8f5"
    sha256 cellar: :any_skip_relocation, ventura:        "b4d767e39dd77e765d7f6cf7a859f6681e00dcb564c4d5d59085aa6a75edd8f5"
    sha256 cellar: :any_skip_relocation, monterey:       "b4d767e39dd77e765d7f6cf7a859f6681e00dcb564c4d5d59085aa6a75edd8f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5001cdb2893c5444d7643baac14b0fd975f0d81c79b3be830b2f467413ae596"
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
