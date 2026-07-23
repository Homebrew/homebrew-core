class GitMediate < Formula
  desc "Utility to help resolve merge conflicts"
  homepage "https://github.com/Peaker/git-mediate"
  url "https://github.com/Peaker/git-mediate/archive/refs/tags/1.1.0.tar.gz"
  sha256 "f8bacc2d041d1bef9288bebdb20ab2ee6fbd7d37d4e23c84f8dda27ff5b8ba59"
  license "GPL-2.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "69a57ba7f69a6c867af27eb65efed17666280a53a30c762a7943ab5384205713"
    sha256 cellar: :any, arm64_sequoia: "99ac6bb97c0dacdd5bf9067192fc031f738b5ace8fefae55e464bd5820639232"
    sha256 cellar: :any, arm64_sonoma:  "e5f2cabad4b3400197969d8e34b759634a30676f161a37f29c400d1da0a4f397"
    sha256 cellar: :any, sonoma:        "94b9dbf70889d3a4a70bcc0d7a8079db0c9797bd861fc44a4ddbdfe4486e3bd5"
    sha256 cellar: :any, arm64_linux:   "570da92723300a3fcd66ea2fa46f6e5ce03059a07c12f0a8b2733e35a696ffc4"
    sha256 cellar: :any, x86_64_linux:  "00f6e2e4642851eb2236a4a4aa316f199cd184213040492bbf1747a6aab7de1c"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "libffi"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    system "git", "init", "--initial-branch=main"
    system "git", "config", "merge.conflictstyle", "diff3"
    # This initial commit will be the merge base
    File.write testpath/"testfile", <<~EOS
      BASE
    EOS
    system "git", "add", "testfile"
    system "git", "commit", "-m", "'initial commit'"
    initial_commit = shell_output("git rev-parse --short HEAD").chomp
    # Make complex change in my-branch
    system "git", "checkout", "-b", "my-branch"
    File.write testpath/"testfile", <<~EOS
      BASE and complex changes here
    EOS
    system "git", "commit", "-am", "'add comment'"
    # Add comment in main branch
    system "git", "checkout", "main"
    File.write testpath/"testfile", <<~EOS
      Added a comment here
      BASE
    EOS
    system "git", "commit", "-am", "'complex changes'"
    shell_output "git merge my-branch", 1
    # There's a merge conflict!
    assert_equal File.read(testpath/"testfile"), <<~EOS
      <<<<<<< HEAD
      Added a comment here
      BASE
      ||||||| #{initial_commit}
      BASE
      =======
      BASE and complex changes here
      >>>>>>> my-branch
    EOS
    # Manually apply the simple change (adding a comment) to the other two parts
    File.write testpath/"testfile", <<~EOS
      <<<<<<< HEAD
      Added a comment here
      BASE
      ||||||| #{initial_commit}
      Added a comment here
      BASE
      =======
      Added a comment here
      BASE and complex changes here
      >>>>>>>
    EOS
    # The conflict is now trivial, so git-mediate can resolve it
    system bin/"git-mediate"
    assert_equal File.read(testpath/"testfile"), <<~EOS
      Added a comment here
      BASE and complex changes here
    EOS
  end
end
