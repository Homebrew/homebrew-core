class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/5.0.1.tar.gz"
  sha256 "7f43df3cca7bb4ea443b4159edd7a204c8d771890a69a50a190dc9543760ca21"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9df8a6228e452d2057a50a4e3360c6227bdb19110e60aae1cca15333ee26fa92"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9df8a6228e452d2057a50a4e3360c6227bdb19110e60aae1cca15333ee26fa92"
    sha256 cellar: :any_skip_relocation, monterey:       "59b2312bf1a953388c55e9cc8e451b0461b220244c504ab581449258b2dfcfb1"
    sha256 cellar: :any_skip_relocation, big_sur:        "59b2312bf1a953388c55e9cc8e451b0461b220244c504ab581449258b2dfcfb1"
    sha256 cellar: :any_skip_relocation, catalina:       "59b2312bf1a953388c55e9cc8e451b0461b220244c504ab581449258b2dfcfb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51c5894e1f050468024927a882927f17ed9f06b5754a81c9138ba8f61c1788db"
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
