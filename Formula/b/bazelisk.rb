class Bazelisk < Formula
  desc "User-friendly launcher for Bazel"
  homepage "https://github.com/bazelbuild/bazelisk/"
  url "https://github.com/bazelbuild/bazelisk/archive/refs/tags/v1.28.1.tar.gz"
  sha256 "e80f76b9d86f529e9d267ce0d333365ea14ec92b3269f81ab85cbd69edab2793"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazelisk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67df07d7ee863610c15c12a82897f330b43172c2fbee7f6e0efeecea11588ae6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67df07d7ee863610c15c12a82897f330b43172c2fbee7f6e0efeecea11588ae6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67df07d7ee863610c15c12a82897f330b43172c2fbee7f6e0efeecea11588ae6"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b1aef90e89503450a044f99642aaa4864b50995b2da1fc2bfd5e9c4ca3095fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a4c8ef0ed3cc6db983294b50d77b42d20980b77f98733519a502960c488f894"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fdf2ac011fbf9ac9ae5bc6818cc725d7e73d9d75cfaf1bde872f380a5c100fd"
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
