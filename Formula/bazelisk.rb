class Bazelisk < Formula
  desc "User-friendly launcher for Bazel"
  homepage "https://github.com/bazelbuild/bazelisk/"
  url "https://github.com/bazelbuild/bazelisk.git",
      tag:      "v1.10.1",
      revision: "cf1205edacc5bc8a781786b36324922640ea6ac9"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazelisk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc592b8ca05a666976465d3620a7255ddf2cc44cbf5532a7f840477eb7402428"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3aa568fb42d31462693efea8051e7ef2489e1f1f22a07500cfd513b0c7f97cf0"
    sha256 cellar: :any_skip_relocation, monterey:       "7dfdd39866cb60e9a47d4cbf32396b079fe6b07195017475ec832fdb88eb89df"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0589844659d97147c7fab9b3a623192527cfbaed269bf4a502aee0dc2dcef18"
    sha256 cellar: :any_skip_relocation, catalina:       "4b334992c7b2cd433074e100a3675bc07a7ab64de8fbb35beea250d229d12363"
    sha256 cellar: :any_skip_relocation, mojave:         "f774b348b3e1403522e6a67126b9791f20245ea3002c23c4786094d82c9a9507"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49d53dd4a0f10c28bc430501cf4e16fbb90d9ad316076e42c12533ea0daf2261"
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
