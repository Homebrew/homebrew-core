class Bazelisk < Formula
  desc "User-friendly launcher for Bazel"
  homepage "https://github.com/bazelbuild/bazelisk/"
  url "https://github.com/bazelbuild/bazelisk.git",
      tag:      "v1.13.0",
      revision: "48e743d62b87d0c86739e589407f8e8e47f872f3"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazelisk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd5d9a2734548ff08f39a2a53fc7ce4d8719e3bbeff7eb6169197161f0a687b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8448953351ba2335ff7a1d74d869a8fac7a4bad55ab77039f4c8dfd3ef2b95fa"
    sha256 cellar: :any_skip_relocation, monterey:       "5d05bd774c257ee80bc70c778e082a39e6c253397b5c0dcc098d15c5da69aef9"
    sha256 cellar: :any_skip_relocation, big_sur:        "06cdd52b9e0995cda6e967db59051887e2239ea6e214f12dd1be9e19cd587b3d"
    sha256 cellar: :any_skip_relocation, catalina:       "b7ceff633799299633d82f447b6e4ee9343fd55edd7fb52e2220996f9a573d43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97b1f68adb48083b96d2a873c5cd51457cf5998a778129786815f2715df6b40c"
  end

  depends_on "go" => :build

  conflicts_with "bazel", because: "Bazelisk replaces the bazel binary"

  resource "bazel_zsh_completion" do
    url "https://raw.githubusercontent.com/bazelbuild/bazel/036e533/scripts/zsh_completion/_bazel"
    sha256 "4094dc84add2f23823bc341186adf6b8487fbd5d4164bd52d98891c41511eba4"
  end

  def install
    # upstream PR ref, https://github.com/bazelbuild/bazelisk/pull/355
    inreplace "httputil/httputil.go", "github.com/bgentry/go-netrc", "github.com/bgentry/go-netrc/netrc"

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
