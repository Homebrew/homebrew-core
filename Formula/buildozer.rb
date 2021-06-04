class Buildozer < Formula
  desc "Rewrite bazel BUILD files using standard commands"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/4.0.1.tar.gz"
  sha256 "c28eef4d30ba1a195c6837acf6c75a4034981f5b4002dda3c5aa6e48ce023cf1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6e6fbe3529f8024adcfb4a07a878d24290e0005bdb139a370f955750311470c6"
    sha256 cellar: :any_skip_relocation, big_sur:       "a4d0c0665fff008552b629d97d0194a47e272e110fa01843fc95042163ae8d53"
    sha256 cellar: :any_skip_relocation, catalina:      "9860c62aa97c12fdf060ec4046bddecd00235d420649ceccd23a290c251ef4bd"
    sha256 cellar: :any_skip_relocation, mojave:        "8dd939f4e3e8575d5ad4f8a493f318a5f6659dbb9efc52a53fc3ca3821bd59e8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./buildozer"
  end

  test do
    build_file = testpath/"BUILD"

    touch build_file
    system "#{bin}/buildozer", "new java_library brewed", "//:__pkg__"

    assert_equal "java_library(name = \"brewed\")\n", build_file.read
  end
end
