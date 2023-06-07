class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/v6.1.2.tar.gz"
  sha256 "977a0bd4593c8d4c8f45e056d181c35e48aa01ad4f8090bdb84f78dca42f47dc"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08be2233ff8d7297f28cce57e90454baf8c88c59ae4f57e87d1e3ba8a1c2c840"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08be2233ff8d7297f28cce57e90454baf8c88c59ae4f57e87d1e3ba8a1c2c840"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08be2233ff8d7297f28cce57e90454baf8c88c59ae4f57e87d1e3ba8a1c2c840"
    sha256 cellar: :any_skip_relocation, ventura:        "3989339a9337e6dfa39e4b13b199c0aaaa11ebf3c21f0e6224e3a4d8fb683965"
    sha256 cellar: :any_skip_relocation, monterey:       "3989339a9337e6dfa39e4b13b199c0aaaa11ebf3c21f0e6224e3a4d8fb683965"
    sha256 cellar: :any_skip_relocation, big_sur:        "3989339a9337e6dfa39e4b13b199c0aaaa11ebf3c21f0e6224e3a4d8fb683965"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c578f4f1515e7dba05e90d1927ff4173d1e5a2ba424105a1a6032882a23a743"
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
