class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/6.0.1.tar.gz"
  sha256 "ca524d4df8c91838b9e80543832cf54d945e8045f6a2b9db1a1d02eec20e8b8c"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f13fe65c6249b2727c737d17eaf70ca2e5a1a9759e0a657270f134ce135c092"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f13fe65c6249b2727c737d17eaf70ca2e5a1a9759e0a657270f134ce135c092"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f13fe65c6249b2727c737d17eaf70ca2e5a1a9759e0a657270f134ce135c092"
    sha256 cellar: :any_skip_relocation, ventura:        "7426f6b85a67df5511ccd9c5af20d2edd7b74bca1aa5a52d9e20857abd3b82a9"
    sha256 cellar: :any_skip_relocation, monterey:       "7426f6b85a67df5511ccd9c5af20d2edd7b74bca1aa5a52d9e20857abd3b82a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "7426f6b85a67df5511ccd9c5af20d2edd7b74bca1aa5a52d9e20857abd3b82a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15366f0f14c366e2120b44e90c06262ddcceaecd60c630e15c0c77d9ea20c00f"
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
