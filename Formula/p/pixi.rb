class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.84.0.tar.gz"
  sha256 "b71fd5f825d8a05c2854e91d86b2ac6fb2b16a37725d48f00919b3dbd6befc92"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "13d2e7fc6bfb3d04cf29b674a09f2500bd18bb7014a64314354ff16caef4ffb2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "aeb7b80e8658943ec32da4a7ee7a3f13ed48a02ba63579bebd0b60980d473eda"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "901015fea190fa87d13a65cc2cec4c665b55a17d6e5b301208904d2ed8c61169"
    sha256 cellar: :any,                 arm64_linux:       "5cb8443ecc58fade687285d07ee94b56d185c1167881ddf01fc1fa980ae4b950"
    sha256 cellar: :any,                 x86_64_linux:      "a99c1fce58fe9ff7dc66215621c7fd3f147f4a9b207c383851c822400ffe9fca"
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
