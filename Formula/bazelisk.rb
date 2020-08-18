class Bazelisk < Formula
  desc "User-friendly launcher for Bazel"
  homepage "https://github.com/bazelbuild/bazelisk/"
  url "https://github.com/bazelbuild/bazelisk.git",
      tag:      "v1.6.1",
      revision: "6f5ce4b2ec4110bbaa9a43ec1b054af7504887d5"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazelisk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "627e1557a552c5ed5eddfb53126ed152752e209d3b58061ad418ba9fc0290259" => :catalina
    sha256 "a247e13b854c070f5cd7a3f41cafd000873784e784dba6ebfe77966a260f2c65" => :mojave
    sha256 "179ad490882d4761a713d02f0d715fa4bd131910446c984ad107ee3c87b52cdb" => :high_sierra
  end

  depends_on "go" => :build

  conflicts_with "bazel", because: "Bazelisk replaces the bazel binary"

  resource "bazel_zsh_completion" do
    url "https://raw.githubusercontent.com/bazelbuild/bazel/3.4.1/scripts/zsh_completion/_bazel"
    sha256 "4094dc84add2f23823bc341186adf6b8487fbd5d4164bd52d98891c41511eba4"
  end

  def install
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = "amd64"

    system "go", "build", *std_go_args, "-ldflags", "-X main.BazeliskVersion=#{version}"

    bin.install_symlink "bazelisk" => "bazel"

    resource("bazel_zsh_completion").stage do
      zsh_completion.install "_bazel"
    end
  end

  test do
    ENV["USE_BAZEL_VERSION"] = Formula["bazel"].version
    assert_match /Bazelisk version: #{version}/, shell_output("#{bin}/bazelisk version")

    # This is an older than current version, so that we can test that bazelisk
    # will target an explicit version we specify. This version shouldn't need to
    # be bumped.
    ENV["USE_BAZEL_VERSION"] = "0.28.0"
    assert_match /Build label: 0.28.0/, shell_output("#{bin}/bazelisk version")
  end
end
