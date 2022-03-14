class GitCliff < Formula
  desc "Highly customizable changelog generator"
  homepage "https://github.com/orhun/git-cliff"
  url "https://github.com/orhun/git-cliff/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "045fb10ad0ee340172397f2bb6521c7ee0a83dca2c9f9d177300601f6c60184f"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf7e85ca5f110ab62f179598cbf67d80eb51c3d1b4512c42f7ef033ff2a25236"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a13032be2763d514e147e66d3ac6d77f56101b8149f5ca2d6488bfee8c798e7"
    sha256 cellar: :any_skip_relocation, monterey:       "5252c46e0f9cb72da81b52fb8c05c93d5dc33ded4dfc62926a717aec60a87a12"
    sha256 cellar: :any_skip_relocation, big_sur:        "1395afb22b947bbe0144c09e161faa681563423a237bd073ea162d0d705bcdbd"
    sha256 cellar: :any_skip_relocation, catalina:       "c5fd122113117d403dc8e80b38d338282b37036482678d9e14011ba2836a3659"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4286ead0329cbd4289aed73cbd6fd1d466ef9fcfdd18ec9c9a6be6b610e60e65"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "git-cliff")

    ENV["OUT_DIR"] = buildpath
    system bin/"git-cliff-completions"
    bash_completion.install "git-cliff.bash"
    fish_completion.install "git-cliff.fish"
    zsh_completion.install "_git-cliff"
  end

  test do
    system "git", "cliff", "--init"
    assert_predicate testpath/"cliff.toml", :exist?

    system "git", "init"
    system "git", "add", "cliff.toml"
    system "git", "commit", "-m", "chore: initial commit"
    changelog = "### Miscellaneous Tasks\n\n- Initial commit"
    assert_match changelog, shell_output("git cliff")
  end
end
