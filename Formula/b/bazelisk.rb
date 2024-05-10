class Bazelisk < Formula
  desc "User-friendly launcher for Bazel"
  homepage "https://github.com/bazelbuild/bazelisk/"
  url "https://github.com/bazelbuild/bazelisk/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "3c2303d45562cf7a9bc64ad41b670f38c2634bf8ba5b3acffa2997577955b3e0"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazelisk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8c61e7366d3636a2ee26b8420d625984754c2f20b1b9a5333a6b93fb70efe38b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8bb3d9debf22b55a4f04ebdc51a7c5fd62d945c0eceaac2ad70a8a987388ae8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a822f5596edc3a8d474b22d8b6dbbd27b57b5ccaaabf2a556fba4ebc116549b"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a5cd87897d8c349c6668e78aec4ee77571c140e829e6ade92ae5ea0d7b20fb4"
    sha256 cellar: :any_skip_relocation, ventura:        "31a7bd108a55dcac58ed31394ebda659d18426ea7d6a51c95e59e7dbea8f523f"
    sha256 cellar: :any_skip_relocation, monterey:       "91cb0c4ec3b42d808f759edf356e7e5e5fb3bf87df3d05a287aaa5e5e9618787"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "391f803a69bb201c495ca9ab6d65e90b1f27a29e49cb0d61b9e81b241fde5129"
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
