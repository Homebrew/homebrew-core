class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.39.3.tar.gz"
  sha256 "bad86e42e692493e6de33026ecc835da2877d8796a30d4ed4da480e203ccb7f4"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03d6cad60ce1ef1a1f4c5bfc8ea4911a037bfaebc6f81e4bc2f0f4130a843bf7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3b34826a8813bb2d8da2003f66886093ba7fdf7ce275b999ca98fac0ae3e6fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d44e6649c97f7a5579708c7c28683b04e349311f00d686150ec6d7e476231735"
    sha256 cellar: :any_skip_relocation, sonoma:        "899083814875fe0d8503f11ce48d3bafc4bd1bb14ad11e0c8a8b843b37027d37"
    sha256 cellar: :any_skip_relocation, ventura:       "ecf9cff01ff791929361db44661448adb6653d5c73e0bdb5ace73cc7bee461e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc87fc61bf8e134ff681ed989fd0c6094baca739d703789ea73c71aabc141d4f"
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
