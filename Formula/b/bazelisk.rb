class Bazelisk < Formula
  desc "User-friendly launcher for Bazel"
  homepage "https://github.com/bazelbuild/bazelisk/"
  url "https://github.com/bazelbuild/bazelisk.git",
      tag:      "v1.19.0",
      revision: "c7c6c19799ff408c48bdce6b7557217ad0050b17"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazelisk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd6823ba3af14f849242f972c28717afa5d1f4539a20c65d44f835b32570800f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40b91a13c925c9464df387d3f25d3968bc694b6de8a777ad47cce4b6a66862d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d7a20c0c5863ee544ad425344008cee4a70376dd0caae524c80e94cec78b559"
    sha256 cellar: :any_skip_relocation, sonoma:         "020026058eaa3dac5787a4d9fe717417cad60ebdef9504733b70e643b091787b"
    sha256 cellar: :any_skip_relocation, ventura:        "d26322a5eb69084ccfd3d2e81f8d3b33825b352f6d07c845ec42d8277a24cfd0"
    sha256 cellar: :any_skip_relocation, monterey:       "dace3a991562730bd3afea279b62efdb017e91c6f1108813b417facf0da436fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecd8e5add73f7190eb40a7f28fa8ac38bb3f01852930c07f0548e8568bcbdee5"
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
