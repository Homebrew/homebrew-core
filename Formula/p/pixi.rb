class Pixi < Formula
  desc "Package management made easy"
  homepage "https://pixi.sh"
  url "https://github.com/prefix-dev/pixi/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "23d14a2b8216ca7f0e7acc25468ee103f34d2f7062e70f12c0d07e6a8a68b3ea"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de93234461d045b1ab78863650e2d9afd9125256fa6705183f4a3ec7837349eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1ba74a2693be498d535834e733b3e70a215154077997c3a05dae666bff3657d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78c22df39d321f0da29304ff4ca1dd743dd87e2f48d69b47bc89977857395883"
    sha256 cellar: :any_skip_relocation, sonoma:        "e14bb3806eccafe3cb70b1cb43ce981a39215e244484c233fc382b4a5773ee0f"
    sha256 cellar: :any_skip_relocation, ventura:       "d5748017c7e8e51836a3fdb65b59d57841fb6af51fb70b4881d7c32217725939"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8b94a088f1b47fb80f1c1cb00031d8970e7fc6c4e30cae109fa18d060604ff3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39f570680df875b5ddb774caca208a43d6d432068d07dbba674abcfda45915c8"
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
