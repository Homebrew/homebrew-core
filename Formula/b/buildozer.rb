class Buildozer < Formula
  desc "Rewrite bazel BUILD files using standard commands"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/v8.2.0.tar.gz"
  sha256 "444a9e93e77a45f290a96cc09f42681d3c780cfbf4ac9dbf2939b095daeb6d7d"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0909649729dafea5fd0ccb91e8b3590f6a63558f24be5632bfcddc22ebba445c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0909649729dafea5fd0ccb91e8b3590f6a63558f24be5632bfcddc22ebba445c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0909649729dafea5fd0ccb91e8b3590f6a63558f24be5632bfcddc22ebba445c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b9ee400118b5281b8ec095d934d8ebc18c167d186091919307b304bc6a33717"
    sha256 cellar: :any_skip_relocation, ventura:       "5b9ee400118b5281b8ec095d934d8ebc18c167d186091919307b304bc6a33717"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab44ac0ff398a7fe9b123b9adb8b7bb0c8986f87e6a4969323894e317b510946"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "808243719a5649c11847ba0da7d12263b12be182f7b1a1163c18a1e4bf106e7e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./buildozer"
  end

  test do
    build_file = testpath/"BUILD"

    touch build_file
    system bin/"buildozer", "new java_library brewed", "//:__pkg__"

    assert_equal "java_library(name = \"brewed\")\n", build_file.read
  end
end
