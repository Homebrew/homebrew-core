class Buildozer < Formula
  desc "Rewrite bazel BUILD files using standard commands"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/v8.0.1.tar.gz"
  sha256 "91727456f1338f511442c50a8d827ae245552642d63de2bc832e6d27632ec300"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9adb34e306ebd73cc41fb43e7cab2e5383b0fac5c25a38de31b115a2bddd87b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9adb34e306ebd73cc41fb43e7cab2e5383b0fac5c25a38de31b115a2bddd87b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9adb34e306ebd73cc41fb43e7cab2e5383b0fac5c25a38de31b115a2bddd87b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "2964ec3acb6542c537132bbf29971febf0874bd3b538f18f9fdfbaa4d7f53f1e"
    sha256 cellar: :any_skip_relocation, ventura:       "2964ec3acb6542c537132bbf29971febf0874bd3b538f18f9fdfbaa4d7f53f1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8ad43e89802dbbedc88fdd3b59aaeaa73bcb4b82cfb662bee0f564be0399b4f"
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
