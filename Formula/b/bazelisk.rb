class Bazelisk < Formula
  desc "User-friendly launcher for Bazel"
  homepage "https://github.com/bazelbuild/bazelisk/"
  url "https://github.com/bazelbuild/bazelisk/archive/refs/tags/v1.29.0.tar.gz"
  sha256 "7e4c7b8ade016052e63c1553cb4fbe0c4fe921e1e66913d49eef074ed894e933"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazelisk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0824ffd0ab8116ca041650a90ea808cc2c119c348f0bca2da8472d8b704b1e76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0824ffd0ab8116ca041650a90ea808cc2c119c348f0bca2da8472d8b704b1e76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0824ffd0ab8116ca041650a90ea808cc2c119c348f0bca2da8472d8b704b1e76"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f53eadd7c371006455391e012378dda2289a84e6354b18e00656119815aa6c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0526ff4378067e5c637b4caf556feb86288c1175f1da187d045bb8291b2eaae4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9cff7e5590735e1da0dcfe4bae080a0a7d278c4cda615d270451c2d145f4114"
  end

  depends_on "go" => :build

  conflicts_with "bazel", because: "Bazelisk replaces the bazel binary"

  resource "bazel_zsh_completion" do
    url "https://raw.githubusercontent.com/bazelbuild/bazel/036e5337f63d967bb4f5fea78dc928d16d0b213c/scripts/zsh_completion/_bazel"
    sha256 "4094dc84add2f23823bc341186adf6b8487fbd5d4164bd52d98891c41511eba4"
  end

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/bazelbuild/bazelisk/core.BazeliskVersion=#{version}")

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
