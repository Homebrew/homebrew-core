class Bazelisk < Formula
  desc "User-friendly launcher for Bazel"
  homepage "https://github.com/bazelbuild/bazelisk/"
  url "https://github.com/bazelbuild/bazelisk.git",
      tag:      "v1.18.0",
      revision: "3f0897a551b5dbec6dfabad8662cca7e9028ad59"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazelisk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9857ae6bd3b3f6ee4848ca656337274fb8e755d5314485576de3d55564c26aa7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e2e8e10623bced48f21de98cc9c2df20d9a469f651834741131950f7be72341"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8414692076be9f9828079662bf25868b8303c1d3a837b0702dc74fee82307c78"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "713c7cbb0f9a62ce70590ed05a708729f765b8d0ccd0d0ae450d19a1fd850bce"
    sha256 cellar: :any_skip_relocation, sonoma:         "af46b00e3975eca1f2bf52382671dd181d47a707825183679b1909ab2ee4b653"
    sha256 cellar: :any_skip_relocation, ventura:        "46e48e3cdc4cb9d80e1b2cd94d81c08f590179370655f8acae3bbbbe8e4a22d6"
    sha256 cellar: :any_skip_relocation, monterey:       "b51b9a35cd3b7053618c70aaa2baab621a9b9d7ccdc4c2403202291bc05dd71f"
    sha256 cellar: :any_skip_relocation, big_sur:        "dbe586b0da8c7bdcd391ba1ca52830846db491566c4d2e19e0e585a01f65de02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9b0b8bc184b022a101560244285ee27a3c31293476cbf2474194dd8abc8db5f"
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
