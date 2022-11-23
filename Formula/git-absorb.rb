class GitAbsorb < Formula
  desc "Automatic git commit --fixup"
  homepage "https://github.com/tummychow/git-absorb"
  url "https://github.com/tummychow/git-absorb/archive/0.6.9.tar.gz"
  sha256 "feaee35e6771d66d6d895a69d59d812cfbcabbecaa70ece64f87528a8c3c2fb5"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0f3d41d8445e31714d8d66f0d1a0f6aae2e2299f1f025e3c415c3d11991bd00"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83c16e3ffef3dd481430b749205ae3641a59afefb9310e47e1115ff69b74af3d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa6b23c233a0d98cfb89d4bb176fdbe2df7b50dd4ee5a2240bceaae122f9a75c"
    sha256 cellar: :any_skip_relocation, ventura:        "77884b0a9421cc5c48500e3f0b628b32267d6f8b1367dbb70c48910a4376a232"
    sha256 cellar: :any_skip_relocation, monterey:       "f25d3d5001d76c1b63b81fce361edc226715dc836976db61a12f6f549357544e"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa3c6be5f0a957b0b8bb09c747fe53edfc887b7ee54de7ffdeafe0894e4dc737"
    sha256 cellar: :any_skip_relocation, catalina:       "a9477274dcab704bad3fe12491219cab7ceb34e86f33837bc6f167bac360b281"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03f77860b7c154728702b956ac364f0d063384272cca1c2f9af915fa8adca56f"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "Documentation/git-absorb.1"

    generate_completions_from_executable(bin/"git-absorb", "--gen-completions")
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
