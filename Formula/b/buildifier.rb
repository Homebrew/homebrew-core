class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/v7.1.1.tar.gz"
  sha256 "60a9025072ae237f325d0e7b661e1685f34922c29883888c2d06f5789462b939"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "505d53603fa0258483422ea857ffe07f5e4607547e64e3723e6606181b6e64dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "505d53603fa0258483422ea857ffe07f5e4607547e64e3723e6606181b6e64dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "505d53603fa0258483422ea857ffe07f5e4607547e64e3723e6606181b6e64dd"
    sha256 cellar: :any_skip_relocation, sonoma:         "e2e6c28035a90f8bd75decb763256f8326401b4746b4fc29ba94e1d46a821c9d"
    sha256 cellar: :any_skip_relocation, ventura:        "e2e6c28035a90f8bd75decb763256f8326401b4746b4fc29ba94e1d46a821c9d"
    sha256 cellar: :any_skip_relocation, monterey:       "e2e6c28035a90f8bd75decb763256f8326401b4746b4fc29ba94e1d46a821c9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a50e0244c9c2d376952c17e3c95422fed4661ff276011cd8909c00f5534b11a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./buildifier"
  end

  test do
    touch testpath/"BUILD"
    system "#{bin}/buildifier", "-mode=check", "BUILD"
  end
end
