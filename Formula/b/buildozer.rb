class Buildozer < Formula
  desc "Rewrite bazel BUILD files using standard commands"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/v8.0.3.tar.gz"
  sha256 "573345c2039889a4001b9933a7ebde8dcaf910c47787993aecccebc3117a4425"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3db52d74452bdb105ad56e4e3e4ff7dece673b2bd144464bb4d82c6adaa28be8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3db52d74452bdb105ad56e4e3e4ff7dece673b2bd144464bb4d82c6adaa28be8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3db52d74452bdb105ad56e4e3e4ff7dece673b2bd144464bb4d82c6adaa28be8"
    sha256 cellar: :any_skip_relocation, sonoma:        "9832a6e68e899a076ed070488cb6bf62e52b7c88ff6d416628e760e75a298e50"
    sha256 cellar: :any_skip_relocation, ventura:       "9832a6e68e899a076ed070488cb6bf62e52b7c88ff6d416628e760e75a298e50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bebc60555c5cc6cfb2eca825d84694fa36b2815cf861bbd85a0402c01f29a67"
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
