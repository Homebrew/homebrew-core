class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.68.0.tar.gz"
  sha256 "4b0e1eaf12a2acbd99e1472a2c4a0c1ae71e0de312117c91d17de3130177467a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3bc5559cc8e06dc40224e8207283057bcc79cda4261bb25b5a757f59048ad870"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f566ae271f6e06b86b5b9debadb8977f3f0b24b603a4b9cb3fad128d403faee4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "622c08af9e559b5984ae0ce2f96c87a21ef11c8edf289671b317979c539cd6db"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e1640e91515928da08ba25daa25c6bb51444c96f1a51fceba9f1ca00bc94022"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d17f78e849bca36376552635c5d7aacdf81f006e0e946f87658da5b080b9d1b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40907c0199f8c8e902d764e1fb693c2708d11e39683d672f416a043f9ea11485"
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
