class Bazelisk < Formula
  desc "User-friendly launcher for Bazel"
  homepage "https://github.com/bazelbuild/bazelisk/"
  url "https://github.com/bazelbuild/bazelisk/archive/refs/tags/v1.31.0.tar.gz"
  sha256 "7aff92f74b73f1560bd1425ca853e6b5f78babef11f4ab10582165fa82a63ad4"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazelisk.git", branch: "master"

  bottle do
    manifest_sha256 "5982a4fc5db8b745983665360b60653939bbf1a49f6109578905a731680d730a"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9833f0f7310b065421ccbca2938508da2b850c08b1483e39bd8852791480b194"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9833f0f7310b065421ccbca2938508da2b850c08b1483e39bd8852791480b194"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9833f0f7310b065421ccbca2938508da2b850c08b1483e39bd8852791480b194"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bb646ad128a7f03db713beb21e860f7b6b278c81fd7924e1545f56f8016786b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b747bd90f2433f349c64acb2c3c0bf81fa57bf7b8d58c7a0c4871808c6e7054c"
  end

  depends_on "go" => :build

  conflicts_with "bazel", because: "Bazelisk replaces the bazel binary"

  resource "bazel_zsh_completion" do
    url "https://raw.githubusercontent.com/bazelbuild/bazel/036e5337f63d967bb4f5fea78dc928d16d0b213c/scripts/zsh_completion/_bazel"
    sha256 "4094dc84add2f23823bc341186adf6b8487fbd5d4164bd52d98891c41511eba4"
  end

  # `test do` block downloads a Bazel release
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-X github.com/bazelbuild/bazelisk/core.BazeliskVersion=#{version}")

    bin.install_symlink "bazelisk" => "bazel"

    resource("bazel_zsh_completion").stage do
      zsh_completion.install "_bazel"
    end
  end

  test do
    ENV["USE_BAZEL_VERSION"] = system_version = Formula["bazel"].version
    output = shell_output("#{bin}/bazelisk version")
    assert_match "Bazelisk version: #{version}", output
    assert_match "Build label: #{system_version}", output

    # Test an older version that bazelisk will fetch
    ENV["USE_BAZEL_VERSION"] = fetched_version = "7.6.1"
    assert_match "Build label: #{fetched_version}", shell_output("#{bin}/bazelisk version")
  end
end
