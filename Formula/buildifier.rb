class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/4.2.3.tar.gz"
  sha256 "614c84128ddb86aab4e1f25ba2e027d32fd5c6da302ae30685b9d7973b13da1b"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ec784a3f54583a43dfc82e6b77cc3ec83c887d37e4b6b2414b1d533306c5ea7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2ec784a3f54583a43dfc82e6b77cc3ec83c887d37e4b6b2414b1d533306c5ea7"
    sha256 cellar: :any_skip_relocation, monterey:       "3f12f2c43a50ddd88d020bbc84b25008bfc81d200a74f14ea7c78c40b8f69782"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f12f2c43a50ddd88d020bbc84b25008bfc81d200a74f14ea7c78c40b8f69782"
    sha256 cellar: :any_skip_relocation, catalina:       "3f12f2c43a50ddd88d020bbc84b25008bfc81d200a74f14ea7c78c40b8f69782"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b13b6469377ebb2f1952004ea11720d83ddc0e2adbe6e822b585fd6f95a6f47"
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
