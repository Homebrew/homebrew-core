class Bazelisk < Formula
  desc "User-friendly launcher for Bazel"
  homepage "https://github.com/bazelbuild/bazelisk/"
  url "https://github.com/bazelbuild/bazelisk.git",
      tag:      "v1.15.0",
      revision: "c9081741bc1420d601140a4232b5c48872370fdc"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazelisk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3091f430006c2d508b6aeec5c72e2113eb705b5eec7a6234200e6ec6e8214410"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05759943a4d4d3a36363a9bd49e42e3730993b0807cdc5a28268024683f3419c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8cfa3371f7dd3b9282b7dfa32b56286e413f72fc7b505078364d353a707f4510"
    sha256 cellar: :any_skip_relocation, ventura:        "2d8d2bb6637076465947f5a9493465ccccff505f106ea5728c3bfe6fe3061257"
    sha256 cellar: :any_skip_relocation, monterey:       "2d2e6c4e0672fc0b694f5e8f1b88462702f37cc95ba3d1c5f6507d7bc32ca486"
    sha256 cellar: :any_skip_relocation, big_sur:        "d38f3d9a12fb76c9b52ae3ec54bec5f27f0091dc3b2a148187e4c226f618dce3"
    sha256 cellar: :any_skip_relocation, catalina:       "466dafb9697c32990238989f196231c2d5268aa22bbcc500642141f3dbfafb9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03a1c1c57e7ca4b69c3ff1715a6b9263bd82d518fe1ca7be156ea0f0f01d1378"
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
