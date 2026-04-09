class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://github.com/ClementTsang/bottom/archive/refs/tags/0.12.3.tar.gz"
  sha256 "1c70894f0eceb7034075959ff3080cf4706c11d7c012912c24e777abe4e62b70"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dfba9f93eadffefbc588bd0d0f845a5e6b37b611d09a063e568e23d3255a7b76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d539c22b4ee05344c309f32323cc5f62f92938a39a719900324a5a03b3cb1e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "018067224e884195a741cb743e597b5c632c0533708894eef382abe56eac86ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "07ed7e4e4a57ffee9c3355fa8ed4b18d9df11bc8f3cc3670cb0bd05eeff17bb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b2f299ad71b9a03e4208575b7c87095fd6673c775b25d38578ac6856a1ec7ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85cf53c4df47b6f6f551887911783e01a36d26d3cbf80010e235107cb0c86dbd"
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
