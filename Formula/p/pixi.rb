class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.73.0.tar.gz"
  sha256 "d47b057f3a5ffc3541c38ac100e07ab65a69022aa900e413cf34a79bb1bd5c28"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb99eedaf93ffe06e8da30495310c5efc1262439e1c5aaf551f244456b6fa273"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f620a8a6d6aad15245f2efab6ce021f23003e2b72318856042640b5d34a55fd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4caedbb13b177aac9534206b1dc95a0896148759018c40e097a45bbe6b1c79cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa4683ec766cb1670ea7f3509e5458b880d8fcda9a973ff5e37d3b61d69f571f"
    sha256 cellar: :any,                 arm64_linux:   "acaf7c7f92b5301108dcc233800ec932084265b86ac5398fa67beadcd036b493"
    sha256 cellar: :any,                 x86_64_linux:  "58f4d606869af17dfa11c957b0504b71b22b08a43d3b796b0034d7b803d4fe74"
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
