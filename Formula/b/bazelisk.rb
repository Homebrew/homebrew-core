class Bazelisk < Formula
  desc "User-friendly launcher for Bazel"
  homepage "https://github.com/bazelbuild/bazelisk/"
  url "https://github.com/bazelbuild/bazelisk/archive/refs/tags/v1.22.1.tar.gz"
  sha256 "64b584d1019d54cde34123d8da06c718c7a7c591f9fd49a29dccb825b9e95e8c"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazelisk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4eb1cbcac7e006930eea94c2b3bf1d22ad60040dd88334cafa2f727adcd9747f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4eb1cbcac7e006930eea94c2b3bf1d22ad60040dd88334cafa2f727adcd9747f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4eb1cbcac7e006930eea94c2b3bf1d22ad60040dd88334cafa2f727adcd9747f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a8da2c1b38a21cd432a029c90bbbe185913b4fb2096176ab46a7a46846e6970"
    sha256 cellar: :any_skip_relocation, ventura:       "4a8da2c1b38a21cd432a029c90bbbe185913b4fb2096176ab46a7a46846e6970"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f19ac31ae0e5fe09b6b6f4f4164ceb02f3c7962ee1f50b2d8617e564556caf79"
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
