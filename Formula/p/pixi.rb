class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.81.0.tar.gz"
  sha256 "6de3f263642615b772400140562ca0a79db2ef489df2efd2499611225481ac24"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "679c028b24bf2c7f609b55643bc15b34978499d4726f9374f36419bdadd83ae9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4c8b41bc6e0efbce1c65b7d2be5890d0dc3f0c6e7d90a0914d5c7428a1a16963"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "239095d2f3652876ce3391ddb71350495c5b32ce5bea6d069c7e592586f71b35"
    sha256 cellar: :any,                 arm64_linux:       "2c7720e698ffa8c2f631554ddc18a2dd5077e24470f1edee54ee14a8bd4f6336"
    sha256 cellar: :any,                 x86_64_linux:      "251243992e245aa4fed5194d6db7858e23e5dfee586747197815b4fdddde65bf"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
    depends_on "xz" # for liblzma
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
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
