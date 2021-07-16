class Bazelisk < Formula
  desc "User-friendly launcher for Bazel"
  homepage "https://github.com/bazelbuild/bazelisk/"
  url "https://github.com/bazelbuild/bazelisk.git",
      tag:      "v1.10.1",
      revision: "cf1205edacc5bc8a781786b36324922640ea6ac9"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazelisk.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0e543a426db30c40fb9c236b619601c3ded5cc324a0d62b1a6ec0184349a2907"
    sha256 cellar: :any_skip_relocation, big_sur:       "66ae0a8419a07ea0fb0ac2b95095c1a408105e65dd3ea8f19842307199d15ac3"
    sha256 cellar: :any_skip_relocation, catalina:      "375df43fa2a16db3d4c9ffad1d3697fe1dd85c56d494dfc453d9ccca2e147eb1"
    sha256 cellar: :any_skip_relocation, mojave:        "c1029a4d5cbc14c3fc653a6d9d936b01e565f62d9d3358f09101966d4ebcd69f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf60c12cfa46da794c1bf40a7bfe3c72044fce7f6ab6083be8e889b107f69336"
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
