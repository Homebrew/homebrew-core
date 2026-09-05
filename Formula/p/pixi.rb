class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.79.0.tar.gz"
  sha256 "f9d6e099fa0f66fa1287cedb38ea445d4f32e1a598c23b6e1609a11efbd56009"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8575814fa9ca324aafb301a34e7277f6f55fa78664bf1930488b7a15df63616b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be23cc88d2558d9df8ef6006cee06bfb11fa3414b20bd8230546a93eefb42adc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f13d007f466b4fecb40eb93d4f0a7b4d75f355514f1d4657c0f7b137ac26dfd4"
    sha256 cellar: :any,                 arm64_linux:   "8686c5a7762b42104154d1cd066c7b9342ae356400963ea896dddfa827c6d465"
    sha256 cellar: :any,                 x86_64_linux:  "d529edbc4b37d0f0117c30d5b790dc91b758ff4de0bf2b9b89ab3b16fb7b4636"
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
