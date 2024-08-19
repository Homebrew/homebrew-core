class Buildozer < Formula
  desc "Rewrite bazel BUILD files using standard commands"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/v7.1.2.tar.gz"
  sha256 "39c59cb5352892292cbe3174055aac187edcb5324c9b4e2d96cb6e40bd753877"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b617acf50bd20c91ce5558c489e83d1ae1b226d96ee8b2ae8b15dbc8ef3e11f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b617acf50bd20c91ce5558c489e83d1ae1b226d96ee8b2ae8b15dbc8ef3e11f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b617acf50bd20c91ce5558c489e83d1ae1b226d96ee8b2ae8b15dbc8ef3e11f2"
    sha256 cellar: :any_skip_relocation, sonoma:         "5422d9c366e26e9cd7f6d47fe318a1b73e52ed57103df3d347798bd25f792f5e"
    sha256 cellar: :any_skip_relocation, ventura:        "5422d9c366e26e9cd7f6d47fe318a1b73e52ed57103df3d347798bd25f792f5e"
    sha256 cellar: :any_skip_relocation, monterey:       "5422d9c366e26e9cd7f6d47fe318a1b73e52ed57103df3d347798bd25f792f5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "803d8ed373b42e267ea090508338e7d9663f307aac3ebdb8d9c86a6e28f2b423"
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
