class Buildozer < Formula
  desc "Rewrite bazel BUILD files using standard commands"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/6.0.1.tar.gz"
  sha256 "ca524d4df8c91838b9e80543832cf54d945e8045f6a2b9db1a1d02eec20e8b8c"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bff201114314acc635ee12ea7228212968c5ad06bf896c74d2b6c011f52a8f58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bff201114314acc635ee12ea7228212968c5ad06bf896c74d2b6c011f52a8f58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bff201114314acc635ee12ea7228212968c5ad06bf896c74d2b6c011f52a8f58"
    sha256 cellar: :any_skip_relocation, ventura:        "ed3e96060cdf2c3c5c28b780f39702125485fb00791575a8d0ee2105b26e2fef"
    sha256 cellar: :any_skip_relocation, monterey:       "ed3e96060cdf2c3c5c28b780f39702125485fb00791575a8d0ee2105b26e2fef"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed3e96060cdf2c3c5c28b780f39702125485fb00791575a8d0ee2105b26e2fef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84741aef7cea483e52e0ba9eb1da5965eed984a93c68131620b77c74c47ce8cd"
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
