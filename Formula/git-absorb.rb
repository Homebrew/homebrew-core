class GitAbsorb < Formula
  desc "Automatic git commit --fixup"
  homepage "https://github.com/tummychow/git-absorb"
  url "https://github.com/tummychow/git-absorb/archive/0.6.8.tar.gz"
  sha256 "97cbd7aa532fccdd5e32944027167d66e6f4b76d40981d91859d3235c9692b9b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "effe9813a09470b714989406771843ad7f3f4322db339d38d67beee7d39f32cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29ea4aff608be9b7a7fddd93a85f70c0a02cd07b0cc15c19b9b474ba81ea10bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee88634b7e5e15f28fc5403b7193eb8f12caeac6bc038745c4a39e8c004a722b"
    sha256 cellar: :any_skip_relocation, monterey:       "e52f7fbfed67b3197c4835114c582f33110bd30b035ac86bbdfdbe9b3b4f9c58"
    sha256 cellar: :any_skip_relocation, big_sur:        "77479e4f11025a5b533bc0d3455698b0225cb8dba537d3f452f345b3b589b644"
    sha256 cellar: :any_skip_relocation, catalina:       "bdfa2cf72e50a44e9a0e9cd6d5fc7e645f80b8a5c6ea607b4e8dd6c51cf37a5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f72c1ab3e38bae9eefdf1cc1deeebba129c089f2eb57bc933538a2fdaa82cbd4"
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
