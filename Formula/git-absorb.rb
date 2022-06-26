class GitAbsorb < Formula
  desc "Automatic git commit --fixup"
  homepage "https://github.com/tummychow/git-absorb"
  url "https://github.com/tummychow/git-absorb/archive/0.6.7.tar.gz"
  sha256 "f562dbcf68c5f687197e8a594cb58cf102cc17a2e9fcf66dbacb83b49e053bd7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bfa39873cfb6e80a361cada4bfd415f0b86c007860c0b5f3c976f40bb032337"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b42c97a5cd6838adf1757e981e8d3687a0f044f790b8dd3a8da6533f7819b0d"
    sha256 cellar: :any_skip_relocation, monterey:       "9eaf884c1391d3407d6df867c8bf23587205b9b35d219f4fe20e7c9a035429eb"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a3a2219b257d4d24d6fd72fa8dc3176071e8808c0172c6f7d8e2b1fb381917e"
    sha256 cellar: :any_skip_relocation, catalina:       "0c4e29e127af8c32a65575f788ef9d4d6adc7a1a2077801c093344f082e9563e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc3b9646158eea26aed4d2a2b8054a2276d6f02c03b584837c9cc006e4095df7"
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
