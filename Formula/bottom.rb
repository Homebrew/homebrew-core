class Bottom < Formula
  desc "Yet another cross-platform graphical process/system monitor"
  homepage "https://clementtsang.github.io/bottom/"
  url "https://github.com/ClementTsang/bottom/archive/0.9.3.tar.gz"
  sha256 "97dbd9f46d63d70898ec12be8743de5a84151f548f158e71d76c41e8072cd0e5"
  license "MIT"
  head "https://github.com/ClementTsang/bottom.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7b5fbfd324f8648f053c608626366043a3566c35dbfa3648a03c7c24c75b15a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e706b079dd42570a508cd667ff22f2acce0a7a7c90a5fb78ae5fcbb478a7d6b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68be07140a608aad5de41094bea67db79ce1843105fba478ee4312625f482aed"
    sha256 cellar: :any_skip_relocation, ventura:        "41cf75bac7f95f9eb9e25f82e5a41ceb1bd378734553c1f3761ff194b09f099b"
    sha256 cellar: :any_skip_relocation, monterey:       "4b60fc681f3309cdeed20840758fff0fd7debf45cbe450cf308f9025ef0870a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4c7a3cafab59fa6f1928ae1e4c8120ba5140de891f5546015c2839464b6e7c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85afcb544eaf485689d312dc2f888c5395bfe6cfc3f5c6222a70644c7e4099c1"
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
