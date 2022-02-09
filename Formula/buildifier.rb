class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/5.0.0.tar.gz"
  sha256 "09a94213ea0d4a844e991374511fb0d44650e9c321799ec5d5dd28b250d82ca3"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1774a812ccf58ba5639f6868775b9de78bff98a65571eb5d07b2aa231044b4ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1774a812ccf58ba5639f6868775b9de78bff98a65571eb5d07b2aa231044b4ec"
    sha256 cellar: :any_skip_relocation, monterey:       "5037338361f502720564cf384f52805838aa4311f62e355ca501894aac7f13d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "5037338361f502720564cf384f52805838aa4311f62e355ca501894aac7f13d4"
    sha256 cellar: :any_skip_relocation, catalina:       "5037338361f502720564cf384f52805838aa4311f62e355ca501894aac7f13d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c312373e23dee7218482e2e3bef5e989fcc5064fdd6f51e47bea08120a469d6"
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
