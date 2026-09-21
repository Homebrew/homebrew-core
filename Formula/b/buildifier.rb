class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/v10.0.1.tar.gz"
  sha256 "7914e09ee966e7498c4a0c365590f555c741c24b1dee022f60a2284036c2653a"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e4e471f61c74d0a8a61117434d5a738d82f83032f0c930da4b5d2d771db39cf1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e4e471f61c74d0a8a61117434d5a738d82f83032f0c930da4b5d2d771db39cf1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e4e471f61c74d0a8a61117434d5a738d82f83032f0c930da4b5d2d771db39cf1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6dfdcbd0a11a667b54c93554b937d6fd30dce26ff27098eff0cadfa6d18e2857"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3a1879d2fe115560db96dd40e87cf017c7cdaf5f8fa1aff35ca69019118d01df"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./buildifier"
  end

  test do
    touch testpath/"BUILD"
    system bin/"buildifier", "-mode=check", "BUILD"
  end
end
