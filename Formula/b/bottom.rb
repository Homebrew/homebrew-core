class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://github.com/ClementTsang/bottom/archive/refs/tags/0.14.3.tar.gz"
  sha256 "dca5cd43313c7d5c48bd78e95c778943a45b3cc0f418c368f9d2fe5b44456fa9"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78ab2e3726209b580f5988863c650c6d6cf6cd56fe2f74c3075ef060e3803e37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c277269d937befbc5926b6c73ddee3288839e362dbddd5838409749e1d0b702"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33cf3b1792b4f5c61a586e90c303c7abb39b9a9bfdb4860bc2c3aa5626404e0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "62a268ae8a182fa967ac994f3eb1db6f42bc2f2a801779c69c7435d2d9c1fb20"
    sha256 cellar: :any,                 arm64_linux:   "eb6874cc2edea7062e9be1f47e507865a9c2610a8d9261c7966578f4c744c0c7"
    sha256 cellar: :any,                 x86_64_linux:  "8f4f8749d778d314c59dc16d6afaa48e3b27478746e911e04ce8cfc31f559ca3"
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
    pwsh_completion.install "#{out_dir}/completion/_btm.ps1"
    man1.install "#{out_dir}/manpage/btm.1"
  end

  test do
    assert_equal "bottom #{version}", shell_output("#{bin}/btm --version").chomp
    assert_match "error: unexpected argument '--invalid' found", shell_output("#{bin}/btm --invalid 2>&1", 2)
  end
end
