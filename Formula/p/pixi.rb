class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.55.0.tar.gz"
  sha256 "fcf3dc002573980780b27e92d2f10e1b23f82bbb0df3c127bbfdabe0813dfa75"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a91ebb54dcb4b2f873e1cde3c30f4081e7ee342ac93938637a687dfd5ecf7900"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2054dbeab094cff2829bf67ee6557edba55b017ce7098abe1a55d64755fcda1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08e9152ceaff72aeac2c20371a067a9487046d1dd7f631328073b8357848d0bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "00fc3820e0039fe5bf75093aa640165a0420b051326affea9d805813e1593262"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a557f35a4ad9c6797ba74712a8305fed89615221c4923fc2536e89a5cd22a44d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1928dbc4fb632734c8a48650b967831691b241a00ae77ce57c8c08bb86b02039"
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

  def caveats
    ENV["PIXI_INSTALL_MESSAGE"] = <<~EOS
      By default, binaries installed by pixi will be placed into:
        $HOME/.pixi/bin

      You may want to add this to your PATH.
    EOS
  end

  test do
    ENV["PIXI_HOME"] = testpath

    assert_equal "pixi #{version}", shell_output("#{bin}/pixi --version").strip

    system bin/"pixi", "init"
    assert_path_exists testpath/"pixi.toml"
  end
end
