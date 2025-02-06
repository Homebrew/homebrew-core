class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.40.3.tar.gz"
  sha256 "b7cff3f4dd3a1e164f1088d07fe4d20b5830855d481b0811d979074ab0d3bc08"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "722c6cea1f23e2929049d646ec432bdb89672604d3a1de9be85bf07d42ca495a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "816fb1aeb09d14e8a948bb8e6b2177e718dc7882a6bd47cd1b3526236a27f5b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24af7382481d8a5798ec8ebf1016b59f51f2467c9a3f225a339defededd233a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "8472c26b2ffc203396bed0646f711e82f5114d03fea479304049a19d2d9a8e89"
    sha256 cellar: :any_skip_relocation, ventura:       "013879b5fea0d36947a58968db9b07e5fd7242e97822720c7b9330f226cee8ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efc54bd6fa3524d5213f5a17c24fc5635686bc08453f96b0bb4a93d54ccd880f"
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
