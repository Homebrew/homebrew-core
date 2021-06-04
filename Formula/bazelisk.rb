class Bazelisk < Formula
  desc "User-friendly launcher for Bazel"
  homepage "https://github.com/bazelbuild/bazelisk/"
  url "https://github.com/bazelbuild/bazelisk.git",
      tag:      "v1.9.0",
      revision: "1b471ee0935ebf91744bac1d7a51b72007167ddc"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazelisk.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "516e65154591eb845b36666219782c5c6b384e5e13d143ea0a4e33e29fde4ba6"
    sha256 cellar: :any_skip_relocation, big_sur:       "35e01853fe87cbf9b034b3e04b3f84a8e0634625f76a9ee01c022ff46e4a395d"
    sha256 cellar: :any_skip_relocation, catalina:      "3ebb8cdd8eaf5a8977ad328340b1ee408f67729cf91cb6dc856bcd4801850b75"
    sha256 cellar: :any_skip_relocation, mojave:        "cd3141d86b7b78d9404664e2fd00174a800c14db2e98ff9bad8b9f85bd543593"
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
    bazel_version = Hardware::CPU.arm? ? "4.1.0" : "4.0.0"
    ENV["USE_BAZEL_VERSION"] = bazel_version
    assert_match "Build label: #{bazel_version}", shell_output("#{bin}/bazelisk version")
  end
end
