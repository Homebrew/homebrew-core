class Bazelisk < Formula
  desc "User-friendly launcher for Bazel"
  homepage "https://github.com/bazelbuild/bazelisk/"
  url "https://github.com/bazelbuild/bazelisk.git",
      tag:      "v1.14.1",
      revision: "d1565d8213492a2d380c8a07a1061268f12d65bb"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazelisk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f8a221e8ac745a971aef2e25f56c932574ee736f02f47a9ff6162bf54bf3e46"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50baed347ac647c9250516ac5a13338e60c589c86c85547466d5e230163f0686"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "327ec7fc0ef1f8558a2944ef893156a225cf9872ebd045167c19f4290411852d"
    sha256 cellar: :any_skip_relocation, monterey:       "53279b4380ac171a52abd666e4d2789effe2f386eecb62d3dc1d85f1a8bd27ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "6862f66bf4adce9d04951f2c4d056c71b729fffa58c9f1f9002d627ca097694d"
    sha256 cellar: :any_skip_relocation, catalina:       "ebcf90d6643964308afb30c4fccda9ddae994ab4b3876bd48ece4f83aa5f5739"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d3abd36e1dc56ad09700297d36694def14a66e37fe03997c90a35bff52fc19a"
  end

  depends_on "go" => :build

  conflicts_with "bazel", because: "Bazelisk replaces the bazel binary"

  resource "bazel_zsh_completion" do
    url "https://raw.githubusercontent.com/bazelbuild/bazel/036e533/scripts/zsh_completion/_bazel"
    sha256 "4094dc84add2f23823bc341186adf6b8487fbd5d4164bd52d98891c41511eba4"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.BazeliskVersion=#{version}")

    bin.install_symlink "bazelisk" => "bazel"

    resource("bazel_zsh_completion").stage do
      zsh_completion.install "_bazel"
    end
  end

  test do
    ENV["USE_BAZEL_VERSION"] = Formula["bazel"].version
    assert_match "Build label: #{Formula["bazel"].version}", shell_output("#{bin}/bazelisk version")

    # This is an older than current version, so that we can test that bazelisk
    # will target an explicit version we specify. This version shouldn't need to
    # be bumped.
    bazel_version = Hardware::CPU.arm? ? "4.1.0" : "4.0.0"
    ENV["USE_BAZEL_VERSION"] = bazel_version
    assert_match "Build label: #{bazel_version}", shell_output("#{bin}/bazelisk version")
  end
end
