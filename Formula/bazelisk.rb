class Bazelisk < Formula
  desc "User-friendly launcher for Bazel"
  homepage "https://github.com/bazelbuild/bazelisk/"
  url "https://github.com/bazelbuild/bazelisk.git",
      tag:      "v1.14.0",
      revision: "4dd53d9473795acb1ab4401428d038507b26321b"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazelisk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "244f8ea62d782486de472b06e2ef5b15c9692287a74394ed59804be67f4ca4ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c1cc123db545ce0d677ab68ba45bc545b0220d695626fcffb6b3ff8675125253"
    sha256 cellar: :any_skip_relocation, monterey:       "3983b8070de9fee187f04077811e552694c7786af07c9ca9de1432d96fca622f"
    sha256 cellar: :any_skip_relocation, big_sur:        "300c27793dc9f37567810cfae30fe607b739a216448de3314c0a70fb5c8e4ca8"
    sha256 cellar: :any_skip_relocation, catalina:       "ae3934fbef48a06a45f192b34c8d0d01e8053fb8c3f4e91feff8d2b9db01211c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7ba0c0b43650c0154080131e2eb1e4a50b11d04ff9c1f0cac2f58e8522e9a52"
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
