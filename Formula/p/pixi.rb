class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.66.0.tar.gz"
  sha256 "37be89e8b089b78b5f65356688258771f34434c545bcccaafde7948d59c2bccd"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "24228ad1f522d32fb53b3ba2645dc43b781cc17909f4dd1656138ffa33179920"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8752fb6ac067169be06a30fd80bd2054c6bff1d16491ad4ab256df250d12f1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecc7d56efefd7d117453defe95000ce7df672a47dfb4c52938e753e5f4b3d5d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a5a27543e44e8f96c137c5528a576e293c1a03fba57b269d5cc0d09bcc44887"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec1566ce17f69ae84b410943635c45c52658f68768e089011f68a293274aa308"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e6d9e84e23bdb80c1140187bc4cc0a45b1fb1f2765b53729473839b4898792c"
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
