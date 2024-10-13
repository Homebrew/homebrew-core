class Buildozer < Formula
  desc "Rewrite bazel BUILD files using standard commands"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/v7.3.1.tar.gz"
  sha256 "051951c10ff8addeb4f10be3b0cf474b304b2ccd675f2cc7683cdd9010320ca9"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5fd1ab10de9a60d460328907b840771d03320e16e6175b204e7f16d8f33d3d06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec336525cddfbc817e12947f539158a6803993dc077fd3c2ce2c3c0e5a4477c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec336525cddfbc817e12947f539158a6803993dc077fd3c2ce2c3c0e5a4477c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec336525cddfbc817e12947f539158a6803993dc077fd3c2ce2c3c0e5a4477c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "1b7814783caa02e02ff260d8db30aec997649161d5d1e936f35a3fe81b4c108a"
    sha256 cellar: :any_skip_relocation, ventura:        "1b7814783caa02e02ff260d8db30aec997649161d5d1e936f35a3fe81b4c108a"
    sha256 cellar: :any_skip_relocation, monterey:       "1b7814783caa02e02ff260d8db30aec997649161d5d1e936f35a3fe81b4c108a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14fe5048886cb98d3e5163f8ac171f876089b5687432882965a697f2eb4aa5ba"
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
