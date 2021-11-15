class GitAbsorb < Formula
  desc "Automatic git commit --fixup"
  homepage "https://github.com/tummychow/git-absorb"
  url "https://github.com/tummychow/git-absorb/archive/0.6.6.tar.gz"
  sha256 "955069cc70a34816e6f4b6a6bd1892cfc0ae3d83d053232293366eb65599af2f"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a01139732b157c708bf13151074669105cca050159412fd781ed9be5b9afdb93"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "50ec784cd0089d5840025d2b108ac75b9b87b4ec786e9e4766304fc012cb3507"
    sha256 cellar: :any_skip_relocation, monterey:       "73201ddb25921212ac430c95be693d7b65ab5c4221a5a18958be63af69eef95b"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c90abd3d3058854758851749660bab97f06a9b60b01e6eb75da29c3c6fa3941"
    sha256 cellar: :any_skip_relocation, catalina:       "0d9b836c7c18d1284e31fe6d354cbfae95c513fae6855d7d8897dbaab3eacf0e"
    sha256 cellar: :any_skip_relocation, mojave:         "d5f13b0f733d6c2d1cd8c98008fcf51faccd3bd4312dd7742dc6a2cc695d0a34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96f90dd36ce015d992314e9e6b325f4b2549fd2ef6871356f96d8ade728980c0"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "Documentation/git-absorb.1"

    (zsh_completion/"_git-absorb").write Utils.safe_popen_read("#{bin}/git-absorb", "--gen-completions", "zsh")
    (bash_completion/"git-absorb").write Utils.safe_popen_read("#{bin}/git-absorb", "--gen-completions", "bash")
    (fish_completion/"git-absorb.fish").write Utils.safe_popen_read("#{bin}/git-absorb", "--gen-completions", "fish")
  end

  test do
    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS
    system "git", "init"
    (testpath/"test").write "foo"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit"

    (testpath/"test").delete
    (testpath/"test").write "bar"
    system "git", "add", "test"
    system "git", "absorb"
  end
end
