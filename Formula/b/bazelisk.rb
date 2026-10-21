class Bazelisk < Formula
  desc "User-friendly launcher for Bazel"
  homepage "https://github.com/bazelbuild/bazelisk/"
  url "https://github.com/bazelbuild/bazelisk/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "938c875176d6895d1f9cce21d71a76f56f82e88d819f22ed587f124f795aad33"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazelisk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a0fba61b4954deca58c164d41be2a2a2cad6da50e64882932530aff9a9f23628"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a0fba61b4954deca58c164d41be2a2a2cad6da50e64882932530aff9a9f23628"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a0fba61b4954deca58c164d41be2a2a2cad6da50e64882932530aff9a9f23628"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7221dca9a409b90ce9a45754dd8e31beaf9b31a943b5c2248669622781144e8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "715cf2105fb955496d3560ae85ce1fa92d5447a9e7566db928244d5327bf09c9"
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
