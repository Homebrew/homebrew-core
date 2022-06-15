class Bazelisk < Formula
  desc "User-friendly launcher for Bazel"
  homepage "https://github.com/bazelbuild/bazelisk/"
  url "https://github.com/bazelbuild/bazelisk.git",
      tag:      "v1.12.0",
      revision: "40d8ae3b575950523ff42752e0c465a73af8d538"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazelisk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad91ac18b4378bf5b6a60760ae75637cec5035673226907bf483c6b38438f194"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e1142cd0bd29516148b235aeee411ba2656d033f28cf8e763d517ddb48a4428"
    sha256 cellar: :any_skip_relocation, monterey:       "d2ef3476915bf671413d4fee5b482a4f856ce2b1f03f4c3fdc60032281335f83"
    sha256 cellar: :any_skip_relocation, big_sur:        "28fb6adc960a4bd4575031a0d0b41d14fe9058e74f3970839d75fee4d0b75657"
    sha256 cellar: :any_skip_relocation, catalina:       "3753f2dbf8dc7d485a993be7909691e0d901bbbafadbb3804c848c0e98815e7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7ca78dc9a3492a2c15157c574f3fa1286bc8bfa28320138fb41d86d3163ecef"
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
