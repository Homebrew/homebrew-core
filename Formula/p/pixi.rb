class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.84.0.tar.gz"
  sha256 "b71fd5f825d8a05c2854e91d86b2ac6fb2b16a37725d48f00919b3dbd6befc92"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c2f5204db10869c5d964dcb22f20913afd836ee94d76f47ca0cd5df09aec75ed"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "78d23093ce9933ef55bc1f85bd08762629a50a87576f4aa403e7a14c487a8454"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "44340f1d1f1a8b42ccfabcff8b2ff048e760bd684f4f00cc1c04d9b06d3eefcd"
    sha256 cellar: :any,                 arm64_linux:       "567cc4798d694abcf76d69bef81da7174f89715f694f7365e79dc20461e3d265"
    sha256 cellar: :any,                 x86_64_linux:      "add003e01b1defcb8b4770191727ddc56989199ca2c06081d147e37372f66bc9"
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
