class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.84.2.tar.gz"
  sha256 "45bb2eb57c8b499962c2ed9a1683b3f120624318bcda4c4511fbd07a887a6ee6"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ae3c7aa1ba6cb9da65ce6305b3ff032a61d4c9beb279464cb9b6ff9cde266f13"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b211fca0944599b1c41a698d7ee1e8d19aea4ac1981f818738bdf21ea0f0a3f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3fe062ccf14166f5c43cf20c847fad7254d2e3b4a6a731f3004267df06ac545e"
    sha256 cellar: :any,                 arm64_linux:       "f0ec4c11dac2a87d8f619d6fe0d4fed6c05a24f81356a287d257abe6451610ec"
    sha256 cellar: :any,                 x86_64_linux:      "dde1f38a925f75780e02318efa079a529b31f81b51a0c2f03cb293c5c96f2722"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4"
    depends_on "xz" # for liblzma
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
