class Bazelisk < Formula
  desc "User-friendly launcher for Bazel"
  homepage "https://github.com/bazelbuild/bazelisk/"
  url "https://github.com/bazelbuild/bazelisk.git",
      tag:      "v1.16.0",
      revision: "fc3e3d68c42744dc1c01739f9710cc52f4a8258c"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazelisk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4164619666c9de30385edac0ae964902a2602561a228dc0994321713e6483c72"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92434078d6f1ba86390846a59097af9b3a0db940f0e6376caafc6cf05fb50a6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65240ab4464ec1115859b9e22fffe5178b59200172863956e34baa739143bae6"
    sha256 cellar: :any_skip_relocation, ventura:        "b02768b46c323a80f1f0446cbe96d974765cc47633dd95ccea3f684eb174fd5b"
    sha256 cellar: :any_skip_relocation, monterey:       "3d651be37851e3cdff1f9683bf2e25f6debef82ff8a367fbb69aa6751b5f4509"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f88e30b2c2a50ecd9b9506be1adefd1fc1d450f395cc520e473b95a8dfe88e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68cd3a56bee4bb44536d0ad5c9d7132317641b2c63a81e32ab09d243053a97f7"
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
