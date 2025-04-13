class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.45.0.tar.gz"
  sha256 "62d217801de97a459ec303cbc65365c8402178927d59c7c3bde70eb476a4b8ec"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6082cbe25a3bb19ec2763219d57e8238d126b577a04d6625e31a9f32a492d818"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "917512c72403f8364169a0d6f2a3b589cb60dba4e70cde9d333efe750606dcad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c197d7f614272a2a45c073218ef4e2f40508b37b2ed6353e1e696af3e546dcd6"
    sha256 cellar: :any_skip_relocation, sonoma:        "32549d2c1a60533b6eab19c8ac3313760ab9c6a8694bb929829cc416abd99481"
    sha256 cellar: :any_skip_relocation, ventura:       "54ac8bb46d5358101536d341f59d9155aaf24ef2ce3de05b3838fa7e7eb450fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c9ada1dc585bc354ad52cb79ce26b5c25f3e438cc18b85c65a251abf8fe65f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c62ca211d024eb88427eaaf5308727979eae6efcd37c94024c8cf05fa50f641"
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
