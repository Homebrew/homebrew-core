class Bazelisk < Formula
  desc "User-friendly launcher for Bazel"
  homepage "https://github.com/bazelbuild/bazelisk/"
  url "https://github.com/bazelbuild/bazelisk.git",
      tag:      "v1.17.0",
      revision: "70e3e87d4ca23cdbe5439685fb6d2018d69be1e5"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazelisk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2831fe73922802f96703dfe863103ef8112c3460ef342173e746e0400e10dd9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2831fe73922802f96703dfe863103ef8112c3460ef342173e746e0400e10dd9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c2831fe73922802f96703dfe863103ef8112c3460ef342173e746e0400e10dd9"
    sha256 cellar: :any_skip_relocation, ventura:        "9a283624e099ec0c6b4ced72cc0408fc4c94346c428687941667a3b0342b73dd"
    sha256 cellar: :any_skip_relocation, monterey:       "9a283624e099ec0c6b4ced72cc0408fc4c94346c428687941667a3b0342b73dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a283624e099ec0c6b4ced72cc0408fc4c94346c428687941667a3b0342b73dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3724ab14709903c90064ad7eed9b626e3086865f075569557d2b2be074e7c5a"
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
