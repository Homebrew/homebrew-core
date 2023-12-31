class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "857edd8627cac44fbad1cfd7cb72f878ec45bb465d94f01ac888e4b8a8fb9cd2"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aec701cd457405e96d8af07bc187d50995e09b30616a2fe2a7b320adff590bf7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "516d07a1139ffc64c88b9d8fc79c9dd17c19b9145b4b47791fe302155775c549"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b87e33e8fa00134e3cc0566cbcb26ab1adb350da7d82433103721e63f2b12655"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b67c2253cf6eecf4c70b9208efddfedb5a1e2ebc3119810006b3d5ed1a3d1d1"
    sha256 cellar: :any_skip_relocation, ventura:        "bd74906c107bcdd4d5fad2bb23bd7ae4be3dd202d46d5631a6be15a3ef21da9e"
    sha256 cellar: :any_skip_relocation, monterey:       "b9fda6d52ee9c4d9f8b802a6245785dcabeb49a9d511695e0d0e42c88eced3f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "992b8b1141c3c0d78091f170cf15f0b95e5e4bcc4b42d35654d10d4848e55c40"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pixi", "completion", "-s")
  end

  test do
    assert_equal "pixi #{version}", shell_output("#{bin}/pixi --version").strip
    system "#{bin}/pixi", "init"
    assert_path_exists testpath/"pixi.toml"
  end
end
