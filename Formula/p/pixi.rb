class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.72.1.tar.gz"
  sha256 "a7e9f58c948d872d581b6466b9f9b439bc6363fffb3a7eefe3c84d117b713405"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3bfbb1e51607905db0d699bd44a627525b5750ae8a783dcbac0fdd65e86d01d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48bda95c7d23d75d7dd3290ffa3af4b184475830ed5c7c3779697cdbc85d66be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95e27291c385aab469bdd60a13a6b6de44a863631524198a35fe55d5f2b07cd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "c06fb1aa41109e703e9f3b99ac5742112bfbc6b320b5fece0b4553917dc1ebc4"
    sha256 cellar: :any,                 arm64_linux:   "5eee221509711aad4cf5eb615c97946c53ea9a5f4e321303bef416b7bf0466fa"
    sha256 cellar: :any,                 x86_64_linux:  "8055e3443be98ffa7feadcd0a52b7732c87f9d702449b13973c9f030e3f4eb78"
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
