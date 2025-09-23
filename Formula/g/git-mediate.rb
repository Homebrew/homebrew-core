class GitMediate < Formula
  desc "Utility to help resolve merge conflicts"
  homepage "https://github.com/Peaker/git-mediate"
  url "https://github.com/Peaker/git-mediate/archive/refs/tags/1.1.0.tar.gz"
  sha256 "f8bacc2d041d1bef9288bebdb20ab2ee6fbd7d37d4e23c84f8dda27ff5b8ba59"
  license "GPL-2.0-only"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "42134552e6c948a352c7a2819178ca7fdd34254d5932ac9867635a31813dcebe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c8be0d8c2ccb6e709e05b0744a8ae7485692993d492d3dbcac2ff7312bfb56a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5fea46d5954c87f70437d452dc81625aacd6d8538649d7a5b535771d9822026"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b57ee5c16d7e4747d9f255bc02109fc0da671ba7cfda9d13798286bf80958e38"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9b46bfa29542509a7fa1b33dadf15a415dbd154066ea58ec7683861a9ab3544"
    sha256 cellar: :any_skip_relocation, ventura:       "45a20d5499cf2ed0a7c0037459b50222cbcf0d18643142c66a3958bc227b2d09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58caff9b2789c99a435feb86be3fc3f7e6a9b05c4fffba13e8c87b23886eb11a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54dd625814a87c231bc8d8fc83ddb4b3366ca87f068a0a6f63e17ace1e842744"
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
