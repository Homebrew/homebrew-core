class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://github.com/ClementTsang/bottom/archive/refs/tags/0.11.4.tar.gz"
  sha256 "838db91511ff73aab0eeb03f47f77b62bdb78380470078e9785044d75b1139a6"
  license "MIT"
  head "https://github.com/ClementTsang/bottom.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d237401119743393a4b15895965687b32574b86328e663c322013c0448384f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d36705f81ef957370366725c5138586b2c0b72c7ae2ccef07d2000947e02fd9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f4330ff8c281ddff5bf69971cdf1544e77da83280b1bf7520fbabc9624372b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8f9f20252a4d0bdb4b8d2bf172b528819f15bf23f7ef0c7e4b3c7c4304ff457"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1efc4207c4944690cfffe24737eb66031ffbed5e2079cc5786695d28d11e2c78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c724284ccd59e32d354a9fa8b2ff61c8cb2d6f795ad256e047ba07015dd1b41f"
  end

  depends_on "rust" => :build

  def install
    # enable build-time generation of completion scripts and manpage
    ENV["BTM_GENERATE"] = "true"

    system "cargo", "install", *std_cargo_args

    # Completion scripts are generated in the crate's build
    # directory, which includes a fingerprint hash. Try to locate it first
    out_dir = "target/tmp/bottom"
    bash_completion.install "#{out_dir}/completion/btm.bash" => "btm"
    fish_completion.install "#{out_dir}/completion/btm.fish"
    zsh_completion.install "#{out_dir}/completion/_btm"
    man1.install "#{out_dir}/manpage/btm.1"
  end

  test do
    assert_equal "bottom #{version}", shell_output("#{bin}/btm --version").chomp
    assert_match "error: unexpected argument '--invalid' found", shell_output("#{bin}/btm --invalid 2>&1", 2)
  end
end
