class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "326f0326839672d84d4e5efe8ba56e743e84d88693686e5b9fdd64e5ca9dc876"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9bd38ff5d5fdc382392595cd7c48c4aca2ab4a687c50c42437a2bdc4d637db0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2751c95228829d353ed579ab63b6fc240fa629566b366b07b1a8bdcac7a8ccb3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "279b6c1ef40b9f3cf8b461d3e47bf1a057cb78cbf6f864a953ebd36e27efcfae"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb7ce707c3377126bc770191522711a50221c7a09ab8ad173a5c76aedb7fbc48"
    sha256 cellar: :any_skip_relocation, ventura:       "fd53563059e60cbb99d9dbd99bb9cae91914295713270fd76d2ca9e4b9bb4bf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87ae65d7df06f07ad8ea4e6a136c88119468f2c04a59d794bfaa70c18bc3c6ef"
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
