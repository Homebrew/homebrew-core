class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/v6.3.2.tar.gz"
  sha256 "b7187e0856280feb0658ab9d629c244e638022819ded8243fb02e0c1d4db8f1c"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e06dff4f8fd5aa238b92b5088f178d953d90f995ebaa8b0432f6e52ba5d49c82"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e06dff4f8fd5aa238b92b5088f178d953d90f995ebaa8b0432f6e52ba5d49c82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e06dff4f8fd5aa238b92b5088f178d953d90f995ebaa8b0432f6e52ba5d49c82"
    sha256 cellar: :any_skip_relocation, ventura:        "554c2bffdec639d1b835675839ae53435b0f428f4d484e4106308c1af98d5d6e"
    sha256 cellar: :any_skip_relocation, monterey:       "554c2bffdec639d1b835675839ae53435b0f428f4d484e4106308c1af98d5d6e"
    sha256 cellar: :any_skip_relocation, big_sur:        "554c2bffdec639d1b835675839ae53435b0f428f4d484e4106308c1af98d5d6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcc182324cb6f086b1f5f03591bba15fb66ca6694163bd83054590e93542d245"
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
