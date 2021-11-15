class Buildozer < Formula
  desc "Rewrite bazel BUILD files using standard commands"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/4.2.3.tar.gz"
  sha256 "614c84128ddb86aab4e1f25ba2e027d32fd5c6da302ae30685b9d7973b13da1b"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c6b3545708383b47d29db89a2c76d6e3b11f4b5c08bca68ddb0cc4a92305a15"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c6b3545708383b47d29db89a2c76d6e3b11f4b5c08bca68ddb0cc4a92305a15"
    sha256 cellar: :any_skip_relocation, monterey:       "1ca27126d253a39f71be28eca8458d9295942d52aea3d20a79f3017b5102f2ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ca27126d253a39f71be28eca8458d9295942d52aea3d20a79f3017b5102f2ce"
    sha256 cellar: :any_skip_relocation, catalina:       "1ca27126d253a39f71be28eca8458d9295942d52aea3d20a79f3017b5102f2ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8915376deabdae0cb030c737b19329e17b8d4d79870db19ab15ae459c16b33c7"
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
