class Bazelisk < Formula
  desc "User-friendly launcher for Bazel"
  homepage "https://github.com/bazelbuild/bazelisk/"
  url "https://github.com/bazelbuild/bazelisk/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "4e136f6f1212f28d5c6fdd4cfa3f016d7443831fc98ce8b7ee3caee81ef956fa"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazelisk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3cb08dd73eb1ef938f6921e5f25b3832d7aaf6c9befdcccba3b4f713a62a043d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cb08dd73eb1ef938f6921e5f25b3832d7aaf6c9befdcccba3b4f713a62a043d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3cb08dd73eb1ef938f6921e5f25b3832d7aaf6c9befdcccba3b4f713a62a043d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d14bd1ef15d2fca1381839670a7c3562750d295712e1cb0f2d8927e9358c56f1"
    sha256 cellar: :any_skip_relocation, ventura:       "d14bd1ef15d2fca1381839670a7c3562750d295712e1cb0f2d8927e9358c56f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa334b48d146e264c5321f317b3e9c6fba01405ee5d80d0d4f75f576a1071d46"
  end

  depends_on "go" => :build

  conflicts_with "bazel", because: "Bazelisk replaces the bazel binary"

  resource "bazel_zsh_completion" do
    url "https://raw.githubusercontent.com/bazelbuild/bazel/036e5337f63d967bb4f5fea78dc928d16d0b213c/scripts/zsh_completion/_bazel"
    sha256 "4094dc84add2f23823bc341186adf6b8487fbd5d4164bd52d98891c41511eba4"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/bazelbuild/bazelisk/core.BazeliskVersion=#{version}")

    bin.install_symlink "bazelisk" => "bazel"

    resource("bazel_zsh_completion").stage do
      zsh_completion.install "_bazel"
    end
  end

  test do
    ENV["USE_BAZEL_VERSION"] = Formula["bazel"].version
    output = shell_output("#{bin}/bazelisk version")
    assert_match "Bazelisk version: #{version}", output
    assert_match "Build label: #{Formula["bazel"].version}", output

    # This is an older than current version, so that we can test that bazelisk
    # will target an explicit version we specify. This version shouldn't need to
    # be bumped.
    bazel_version = Hardware::CPU.arm? ? "7.1.0" : "7.0.0"
    ENV["USE_BAZEL_VERSION"] = bazel_version
    assert_match "Build label: #{bazel_version}", shell_output("#{bin}/bazelisk version")
  end
end
