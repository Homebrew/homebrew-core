class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/4.2.0.tar.gz"
  sha256 "d49976b0b1e81146d79072f10cabe6634afcd318b1bd86b0102d5967121c43c1"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ff94bff5b693fc07f0f4492e00b8f7f7a02b9473975d7edde63c859e2f0be799"
    sha256 cellar: :any_skip_relocation, big_sur:       "4a40da36ac27505a41280fb7ffd998d9d80907f969297f3a117e577fe2145ed6"
    sha256 cellar: :any_skip_relocation, catalina:      "4a40da36ac27505a41280fb7ffd998d9d80907f969297f3a117e577fe2145ed6"
    sha256 cellar: :any_skip_relocation, mojave:        "4a40da36ac27505a41280fb7ffd998d9d80907f969297f3a117e577fe2145ed6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0dc96ee015fa3c3c1928e977051712eba13345320f8f76482c852fa6610c523"
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
