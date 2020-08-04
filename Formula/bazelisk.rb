class Bazelisk < Formula
  desc "User-friendly launcher for Bazel"
  homepage "https://github.com/bazelbuild/bazelisk/"
  url "https://github.com/bazelbuild/bazelisk.git",
      tag:      "v1.5.0",
      revision: "9f7127db3c137e32a21484f9345bbc0da8301135"
  license "Apache-2.0"
  revision 1
  head "https://github.com/bazelbuild/bazelisk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d1462676651a8d389cdd4114b61d05db442b1b73806797f8033a7c7bf76dc638" => :catalina
    sha256 "30e28be7758c0c4675deb753081bb32b6a9053bdf825dca6087d99c3f17fb3e9" => :mojave
    sha256 "df36ce6e180c27bc5f9edd1ab5e3d34594da5ad9f21a2ded037f6a622c5adf5f" => :high_sierra
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
