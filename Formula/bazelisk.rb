class Bazelisk < Formula
  desc "User-friendly launcher for Bazel"
  homepage "https://github.com/bazelbuild/bazelisk/"
  url "https://github.com/bazelbuild/bazelisk.git",
      tag:      "v1.7.4",
      revision: "3b5aa4468260727974ea62d4e9e810a17649f5b7"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazelisk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0cbe71f38984341f180816f109a0a92309ab6e3c44ea2b827c1ff06aff1e6e68" => :catalina
    sha256 "31ccb18cd07eb6b7703ee66ad364e081b888e000d1c8c7dea892cb16fe33b67f" => :mojave
    sha256 "2bda6c0f9a3a4e2a15feca1cc0224bba67548c24b2f046caf9a5ac6e2f80be82" => :high_sierra
  end

  depends_on "go" => :build

  conflicts_with "bazel", because: "Bazelisk replaces the bazel binary"

  resource "bazel_zsh_completion" do
    url "https://raw.githubusercontent.com/bazelbuild/bazel/036e533/scripts/zsh_completion/_bazel"
    sha256 "4094dc84add2f23823bc341186adf6b8487fbd5d4164bd52d98891c41511eba4"
  end

  def install
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = "amd64"

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
