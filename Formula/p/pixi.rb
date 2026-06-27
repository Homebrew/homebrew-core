class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.71.1.tar.gz"
  sha256 "9bd807aebcb3f32b2db8455352ddbfd97ccefd871f161bb8a9efdcc7dc3a3661"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2abe5cb41117d88968607839e228f1f604843dfcbcf3a3eaa873e71c1d569cfe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ca1ff06680c1b25b37601e57b01fc91fe9e36e1857a8fd340e915342b20d5ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "857e5fa2e6da6fa6ffc63e1aff26db5645fbdcf6467411f4fd21179ffeb60b40"
    sha256 cellar: :any_skip_relocation, sonoma:        "4fb46f68e3e802ef0f5bc986916ff38c87ca04bc1a0d0047eed62979367f1085"
    sha256 cellar: :any,                 arm64_linux:   "c4d819a693db57a23bf8a7604ad3b5835d237a33e0324e596ab1a249eb346a7e"
    sha256 cellar: :any,                 x86_64_linux:  "a4cd462426fbbfc51d597bcb8f52bcd126c4dc3542f2fa6599da9234bbcad352"
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
