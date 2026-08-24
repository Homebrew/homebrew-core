class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.77.1.tar.gz"
  sha256 "693056629d25c8eda813dfd64f5b8aecc418cfb07bcaff14a6410026b8f0bd8a"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "432d9c18b3a5b596e3449aa41057812d56fbb716a2e829f5a75bfb8be3bcb50b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c29643138235a2b0491efdf3ea47b698983f6938982c1ab654cea4da96343224"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c76da9fc89c685108348c0d6e14b04fc35ce67d6c22e01dd13abb0403897ef3"
    sha256 cellar: :any_skip_relocation, sonoma:        "d92b8a5541521b0474b9086b3bbfd6de85a5604d68df2411466e184823030c01"
    sha256 cellar: :any,                 arm64_linux:   "6c148fd6f882cd7e66377e750d67f72ee79cab2418742580f166d2258169171c"
    sha256 cellar: :any,                 x86_64_linux:  "708e07be134b3dc014ba26e3db3d45933ef95596f69a0688281d618de89d551d"
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
