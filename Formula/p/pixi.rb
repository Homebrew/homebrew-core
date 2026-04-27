class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.67.2.tar.gz"
  sha256 "b658db72cc3ce2c56b26935ea6e6b54faac19edca5e697507c929526e0c7dccc"
  license "BSD-3-Clause"
  head "https://github.com/prefix-dev/pixi.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c00e3a359b03ae968fb8022e4684cba594785a1d11c8c2093ef84f532e202163"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "993016fcbca0c1be74629b5e662dcdf0607ab1b90ba51d50bb6caf71aee6c62d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e875dfa5b770cefc2b75d58cfe8d5febd7d9e76a92886d2b3bf3f6d13cc5238d"
    sha256 cellar: :any_skip_relocation, sonoma:        "30895343849ab735b5222ff7bb0314065cee791d52a8fab9bdd620b0c59b3a25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "268020bbf6b377487121354105506571bb9b955d0034deaf8a85a035440469ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e608d3b8d9482fa3afa841be11c3084a150a3cbd6ae02e6f6528c029b7a8965"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
    depends_on "xz" # for liblzma
  end

  def install
    ENV["PIXI_VERSION"] = Utils.safe_popen_read("git", "describe", "--tags").chomp.delete_prefix("v") if build.head?

    ENV["PIXI_SELF_UPDATE_DISABLED_MESSAGE"] = <<~EOS
      `self-update` has been disabled for this build.
      Run `brew upgrade pixi` instead.
    EOS
    system "cargo", "install", *std_cargo_args(path: "crates/pixi")

    generate_completions_from_executable(bin/"pixi", "completion", "-s")
  end

  test do
    ENV["PIXI_HOME"] = testpath

    assert_equal "pixi #{version}", shell_output("#{bin}/pixi --version").strip

    system bin/"pixi", "init"
    assert_path_exists testpath/"pixi.toml"
  end
end
