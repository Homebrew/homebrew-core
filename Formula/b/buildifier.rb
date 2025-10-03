class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/refs/tags/v8.2.1.tar.gz"
  sha256 "53119397bbce1cd7e4c590e117dcda343c2086199de62932106c80733526c261"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c35863552f974d1f58207dfe2bd76d31d55a74f667552e25f85286b1007ba354"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a50bef2309f22e994b9f6f44b8a33461504ab6608d33012fa5a6afece978d8d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a50bef2309f22e994b9f6f44b8a33461504ab6608d33012fa5a6afece978d8d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a50bef2309f22e994b9f6f44b8a33461504ab6608d33012fa5a6afece978d8d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3624c86423fc9d43ad9368eccaa940d87be190dae38ceb835645a066ccd923b"
    sha256 cellar: :any_skip_relocation, ventura:       "c3624c86423fc9d43ad9368eccaa940d87be190dae38ceb835645a066ccd923b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9dc61d443de40465d0ec8e63b575a07c9e262c0d4957871f3ff85f67f040f37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "899c8e182da372a46ea980a6def786aa3f61b4c9e378feba734f24cb24f7ee45"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./buildifier"
  end

  test do
    touch testpath/"BUILD"
    system bin/"buildifier", "-mode=check", "BUILD"
  end
end
