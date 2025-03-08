class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.42.1.tar.gz"
  sha256 "64be792c7e8af811db2fb9ee753c56b21ce6122b4abe321d1f2c35ffbf37d716"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc35290145f11601c7f8188d97ac44f8034ab407663ae89c047c25c3b2c97b5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "36fdd0b30dd0d7ca33e245787d68eebc4db498f7dcd5a0664a2799873506f11a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dacad8dc58b34c4837b0630a12116cd48516d8a7d4c72f2243f1108c4b3329cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "9370d58c7e9992463302dce91f5cfb216f619023e3f7df1f290ed5e5c4f0c704"
    sha256 cellar: :any_skip_relocation, ventura:       "2ade33c8d9488c0c28ed217d72d64ca41cfec9d7469e4fea77faddddfd5ba2fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb7769a9e0077a23b625ab690676394cfa5e42a7f23b8b8d9c54477677a7a47f"
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
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pixi", "completion", "-s")
  end

  test do
    assert_equal "pixi #{version}", shell_output("#{bin}/pixi --version").strip

    system bin/"pixi", "init"
    assert_path_exists testpath/"pixi.toml"
  end
end
