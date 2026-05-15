class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.68.1.tar.gz"
  sha256 "3f8bde01be297af876c2c61c13402888166f15e7d922e7b01df3a1ae00fb9735"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34654c949c3f71db4ee20b1d6c2918f67a3dfa86a3b9f4815d1c6724bda86af2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb6bb93bbd3c0db4bb0c2a77ed11541c9d64109ebfc42d8e5117f82e5adb3b9c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c251a042ae99327547cfb5574ba0ac37f3e138a06b8f6ff15299e6084442f9a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4c3d99b838e4fe14d768eb67db6498a2ad4b27234e20c5c9dafd23a5c4213d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6cacf8f0ec13a29a44437307b4e7a64032e889888ebc618d40206a716c161db4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73c1dfe2d08fee29787df7ab35104820ee7d8d80738148a6cf4e68950a540e0b"
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
