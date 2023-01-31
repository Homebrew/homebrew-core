class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/6.0.1.tar.gz"
  sha256 "ca524d4df8c91838b9e80543832cf54d945e8045f6a2b9db1a1d02eec20e8b8c"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ef7b01c9cefb365922e83936c28828621aec5a4c68f2291330361cf788b2037"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ef7b01c9cefb365922e83936c28828621aec5a4c68f2291330361cf788b2037"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ef7b01c9cefb365922e83936c28828621aec5a4c68f2291330361cf788b2037"
    sha256 cellar: :any_skip_relocation, ventura:        "03e4a82e78586e709ace50d0d1c88c4160931b496db09af136703f98581f61b2"
    sha256 cellar: :any_skip_relocation, monterey:       "03e4a82e78586e709ace50d0d1c88c4160931b496db09af136703f98581f61b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "03e4a82e78586e709ace50d0d1c88c4160931b496db09af136703f98581f61b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "828d2a9f5ea349d181f8bc553a4252b9f7e7728d2c10ee2430530029371ea791"
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
