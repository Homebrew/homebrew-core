class Buildozer < Formula
  desc "Rewrite bazel BUILD files using standard commands"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/v6.1.2.tar.gz"
  sha256 "977a0bd4593c8d4c8f45e056d181c35e48aa01ad4f8090bdb84f78dca42f47dc"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2f49746bf51f8a65ce67753e0d906a89687b38817b586b8fc9042f23079d782"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2f49746bf51f8a65ce67753e0d906a89687b38817b586b8fc9042f23079d782"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2f49746bf51f8a65ce67753e0d906a89687b38817b586b8fc9042f23079d782"
    sha256 cellar: :any_skip_relocation, ventura:        "5efbb140bed9fbd57df0b77d858b9aa7da9f31b836799c9d855c2a80886a961c"
    sha256 cellar: :any_skip_relocation, monterey:       "5efbb140bed9fbd57df0b77d858b9aa7da9f31b836799c9d855c2a80886a961c"
    sha256 cellar: :any_skip_relocation, big_sur:        "5efbb140bed9fbd57df0b77d858b9aa7da9f31b836799c9d855c2a80886a961c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8666d5525cd69b8f32de947919a1eb8682ceb0e0c7aa7076a5e8d207d2ca677d"
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
