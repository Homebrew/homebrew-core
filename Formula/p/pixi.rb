class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.85.0.tar.gz"
  sha256 "e721f21c5e3c5cf6c608392a55b2d65c7d625052d77d233b67452deb35799bf2"
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
    manifest_sha256 "89b80c93e3fb95283ea6cbd74edaae3c385c309ad63f6af9bba576e1b5053591"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3795906248b3508e9a0e89fd6a339f3eaba0b6f04d49774718d17f37f6bd4f69"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1ca915c686d14496869b66c6a0a4c912935aa82121a6ca20ea8d0b2acb78cf43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7bc4b15c576b854933d54a6338d6fb653dcd277d27ac4a099eb09189b6bbc0e0"
    sha256 cellar: :any,                 arm64_linux:       "04d3a87a366eb41d659b78b4f2359bc64a4e07b91623a34aacc55094624cabbf"
    sha256 cellar: :any,                 x86_64_linux:      "c5f7407325721d44fe017df30d0d6cc5510080d2566dde10cf9e6c0d1647ff2a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4"
    depends_on "xz" # for liblzma
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
