class Buildozer < Formula
  desc "Rewrite bazel BUILD files using standard commands"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/5.1.0.tar.gz"
  sha256 "e3bb0dc8b0274ea1aca75f1f8c0c835adbe589708ea89bf698069d0790701ea3"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c19fee167e41f0d485a14ea49548d4e75b56619fc8dac0e911f2fa0fb59928a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c19fee167e41f0d485a14ea49548d4e75b56619fc8dac0e911f2fa0fb59928a6"
    sha256 cellar: :any_skip_relocation, monterey:       "2df8fb4b87991360d76697945d91da54970364f14f7368ef0ac48899cdbac405"
    sha256 cellar: :any_skip_relocation, big_sur:        "2df8fb4b87991360d76697945d91da54970364f14f7368ef0ac48899cdbac405"
    sha256 cellar: :any_skip_relocation, catalina:       "2df8fb4b87991360d76697945d91da54970364f14f7368ef0ac48899cdbac405"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a2a911836ef0839cda28fd8b21dc0ad223984fc98081e9f6063ea2096372a71"
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
