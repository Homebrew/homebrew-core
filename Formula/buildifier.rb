class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/4.0.1.tar.gz"
  sha256 "c28eef4d30ba1a195c6837acf6c75a4034981f5b4002dda3c5aa6e48ce023cf1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e4e94523c894ce25eb78ca146d6b5381d6a410688a4830e646003cbad414d5ad"
    sha256 cellar: :any_skip_relocation, big_sur:       "dfec354e37e8027cfc1adbccd17d88e8ea4781d5653389534fbfb802b71d42d7"
    sha256 cellar: :any_skip_relocation, catalina:      "105cd56c1b0933b8f2afbe283df6a03f7bc038b8b20daa194e5b6e7fc3ed9e6c"
    sha256 cellar: :any_skip_relocation, mojave:        "7898e9f197210a0bb89f8674d07da5160d77790f7cf58507c47718d332214948"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./buildifier"
  end

  test do
    touch testpath/"BUILD"
    system "#{bin}/buildifier", "-mode=check", "BUILD"
  end
end
