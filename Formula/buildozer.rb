class Buildozer < Formula
  desc "Rewrite bazel BUILD files using standard commands"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/6.0.1.tar.gz"
  sha256 "ca524d4df8c91838b9e80543832cf54d945e8045f6a2b9db1a1d02eec20e8b8c"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6484ab820f335038da739b67ab319acacb937cf83849b2ee82198b50a72282e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6484ab820f335038da739b67ab319acacb937cf83849b2ee82198b50a72282e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6484ab820f335038da739b67ab319acacb937cf83849b2ee82198b50a72282e5"
    sha256 cellar: :any_skip_relocation, ventura:        "2a1f20a1e022a11f5910e9a8678658564b3c630d215098f03d749b9f615c2af3"
    sha256 cellar: :any_skip_relocation, monterey:       "2a1f20a1e022a11f5910e9a8678658564b3c630d215098f03d749b9f615c2af3"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a1f20a1e022a11f5910e9a8678658564b3c630d215098f03d749b9f615c2af3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb9a3bcbdb693290d80768af4e75965f3f874b67edd4c8e545a907f37d2f186c"
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
