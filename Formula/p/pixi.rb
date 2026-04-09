class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.67.0.tar.gz"
  sha256 "c9312334495efae40938084355012fa3320d18299c124e5add0de67157c7dc3d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c69686d819384777d6ec8be8b20a936cfe6fd7fb69d67aaeff2570ef8334197"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "634a3e7c194a7155e845d978b09f9c5f038471eecb0997537b6e7ea9c0b7ac14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c8a8213951d142f28a3fa285c2abd65674bc4b7b1c70bf6eb63941fcf298196"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b51a577470224bf648e7a4ac6fa5931d7278a925eb98171dd0321cb64304e28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c395021ee0919cee085ae3b1b9a7c4c017dd105a23ffd5129e60b3c7a559ed34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c418f74d40411fd3295a2729de9805d069f0b9c5106f65f88117f9b8a72f582"
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
