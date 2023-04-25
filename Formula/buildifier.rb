class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/6.1.0.tar.gz"
  sha256 "a75c337f4d046e560298f52ae95add73b9b933e4d6fb01ed86d57313e53b68e6"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1cf72f6a84ac68c673483dff20f738acef7fe532f031b3f9688a2de2669e285"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1cf72f6a84ac68c673483dff20f738acef7fe532f031b3f9688a2de2669e285"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1cf72f6a84ac68c673483dff20f738acef7fe532f031b3f9688a2de2669e285"
    sha256 cellar: :any_skip_relocation, ventura:        "c4de068646c1a991e6c1f49afa0771344ef52db8f39f0f45ef57b664fe8c9919"
    sha256 cellar: :any_skip_relocation, monterey:       "c4de068646c1a991e6c1f49afa0771344ef52db8f39f0f45ef57b664fe8c9919"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4de068646c1a991e6c1f49afa0771344ef52db8f39f0f45ef57b664fe8c9919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6f6a6f29686e10a12c6dd3ebf095bad7a98d892a9241d3e8217e903eaa4186b"
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
