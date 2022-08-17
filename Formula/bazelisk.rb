class Bazelisk < Formula
  desc "User-friendly launcher for Bazel"
  homepage "https://github.com/bazelbuild/bazelisk/"
  url "https://github.com/bazelbuild/bazelisk.git",
      tag:      "v1.12.2",
      revision: "da51894202e245610c774eb81053577f9f3cc14a"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/bazelisk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "357415da1bbc4693035c651d1ce6f1be6522f83180c206d0790cd231afd59b44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c48f4b21b6773047daba340f67e98612a44e7c733c8c38b2c31bc0570663a117"
    sha256 cellar: :any_skip_relocation, monterey:       "8fbe827bbe3ec081ceefa37c83b243a9b14a864cd4d8037c5409d4b3a003dcae"
    sha256 cellar: :any_skip_relocation, big_sur:        "15792aadb9f31666abdb2269d7bfc419fb4ba4aa4cbeafce711d21b1562f93fc"
    sha256 cellar: :any_skip_relocation, catalina:       "c20c259803b34c30974b3ace922b69ea90bae9ddaf734c290f47245752978404"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d1c9e929b8f11faf8563a1d091df34d35f40a0c921a2c230430736c239c2533"
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
