class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://github.com/ClementTsang/bottom/archive/0.9.1.tar.gz"
  sha256 "15136784ba4783c994bbfc1fe978ccf47360b2f2aa14ce37f8d5f93871ec9d57"
  license "MIT"
  head "https://github.com/ClementTsang/bottom.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "622ddf590471dddb4dbd325c8d4ce689d94b1fc0ecf912f905b710b38a545f11"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "669aa4c24a33f2e5f487a38a36c04597da9800f6408f19c9c51c26b667f8bf10"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "147adf66949b1daa21c85eb37c8e87111778617188be0541ac0225772f46758c"
    sha256 cellar: :any_skip_relocation, ventura:        "c9ca0c4f330ec6e999628000ba5096a2e18c13400b38bbd216087a0966b9e76a"
    sha256 cellar: :any_skip_relocation, monterey:       "e7833c993120a0e5cd0f1e02aaf6cda714a2e1e6b3118deccc6a647aab343c8a"
    sha256 cellar: :any_skip_relocation, big_sur:        "33fe4cb5032c5b0ee79b80d4219c4c706ae8d31ac2ca81a1d2bd38ecf249eaaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5291c4a404df04f77dc83a9f9c1c587b5e1bac673790abbdec10f9f9ae2725bc"
  end

  depends_on "rust" => :build

  def install
    # enable build-time generation of completion scripts and manpage
    ENV["BTM_GENERATE"] = "true"

    system "cargo", "install", *std_cargo_args

    # Completion scripts are generated in the crate's build
    # directory, which includes a fingerprint hash. Try to locate it first
    out_dir = "target/tmp/bottom"
    bash_completion.install "#{out_dir}/completion/btm.bash"
    fish_completion.install "#{out_dir}/completion/btm.fish"
    zsh_completion.install "#{out_dir}/completion/_btm"
    man1.install "#{out_dir}/manpage/btm.1"
  end

  test do
    assert_equal "bottom #{version}", shell_output(bin/"btm --version").chomp
    assert_match "error: unexpected argument '--invalid' found", shell_output(bin/"btm --invalid 2>&1", 2)
  end
end
