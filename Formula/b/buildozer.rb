class Buildozer < Formula
  desc "Rewrite bazel BUILD files using standard commands"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/v6.3.2.tar.gz"
  sha256 "b7187e0856280feb0658ab9d629c244e638022819ded8243fb02e0c1d4db8f1c"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62b787d905293f6110f9a0a2f8f145ba6621821bece2dac639b0c1c0077fdb47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62b787d905293f6110f9a0a2f8f145ba6621821bece2dac639b0c1c0077fdb47"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62b787d905293f6110f9a0a2f8f145ba6621821bece2dac639b0c1c0077fdb47"
    sha256 cellar: :any_skip_relocation, ventura:        "74337e7225878806e6f0dc96105e5066a701a31cf3afa31f79c3957b59336ec3"
    sha256 cellar: :any_skip_relocation, monterey:       "74337e7225878806e6f0dc96105e5066a701a31cf3afa31f79c3957b59336ec3"
    sha256 cellar: :any_skip_relocation, big_sur:        "74337e7225878806e6f0dc96105e5066a701a31cf3afa31f79c3957b59336ec3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa1319f411070c8dbae8ef757e3618361dc41130ffa3c43089271161bc0a145e"
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
