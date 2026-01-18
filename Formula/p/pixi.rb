class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.63.1.tar.gz"
  sha256 "350bba330edf8192bc768f29a8509c2ce72933a13490f2e0944c23477445e0a1"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4114fe69635311e8f981d5e4c5b9e6a77a14c1b5ac2f9beea3b416da26adcb1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a68a4a6e16dfe0e9fb25f2f14c7de8185aea43b5bf2fc1bc02ae9f1fc9d11bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "346cd8497cd95b616aebd3640728ed0f1d272d8cbf9e43bab4fa61b76acb3177"
    sha256 cellar: :any_skip_relocation, sonoma:        "637aed98d1a7cda3e29e8a4a74063947f548c44842360e69c8e4d996e5fdbd6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11a85cc1c5243bb535f136f294134da8904182b686785af2fef07ea472598368"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7726b8e8c2f1eb975734b3eda788b5856d890ce53605ba7bea64a200facbf258"
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
