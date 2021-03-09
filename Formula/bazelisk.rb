class Bazelisk < Formula
  desc "User-friendly launcher for Bazel"
  homepage "https://github.com/bazelbuild/bazelisk/"
  url "https://github.com/bazelbuild/bazelisk.git",
      tag:      "v1.7.5",
      revision: "089a39a3f896a43e759e0b494e4acfe2982aca7e"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazelisk.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "73266bab3d913f636851157fdc060c8ac6e1001c4dfccab5e0e84dbb94770aa8"
    sha256 cellar: :any_skip_relocation, catalina: "624a6f20edb7a0f1fe6990320b87478286d721ec0fcff432671350068cb6413d"
    sha256 cellar: :any_skip_relocation, mojave:   "57e61c1c3fedc11a46a96e7b29cb3fdf0d77b123ac6baadfc9e24c26f4fcee83"
  end

  depends_on "go" => :build

  conflicts_with "bazel", because: "Bazelisk replaces the bazel binary"

  resource "bazel_zsh_completion" do
    url "https://raw.githubusercontent.com/bazelbuild/bazel/036e533/scripts/zsh_completion/_bazel"
    sha256 "4094dc84add2f23823bc341186adf6b8487fbd5d4164bd52d98891c41511eba4"
  end

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.BazeliskVersion=#{version}"

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
    ENV["USE_BAZEL_VERSION"] = "0.28.0"
    assert_match "Build label: 0.28.0", shell_output("#{bin}/bazelisk version")
  end
end
