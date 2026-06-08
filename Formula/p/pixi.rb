class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.70.1.tar.gz"
  sha256 "dc3130de2604d96e26395d43b0ef18f3fd63c926bf44d4d8628f1bb8d7df77a7"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6758cbaa27385d35a43ee8f8915c01740111144a219bb90c595783021f442cbf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acaee8b399de44bc564705547d5fb4b45637644485db68be8d5a388cc9472775"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "328fab15359343a56c711aa3fb5a9a69741d98968cc5690eb6b63e7c310c4850"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec28b22c1a6c1fc7df01f82e3ba41d1524b590afde300382a35456356448b4f1"
    sha256 cellar: :any,                 arm64_linux:   "daf4fb32fc816e128e74c8be52819acdaf971901b8a00f749984c4921f282885"
    sha256 cellar: :any,                 x86_64_linux:  "cd90f0bf26a08baff4ea4425e5a64e6d91c2cedd75b8d892c3958534ccd64d5f"
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
