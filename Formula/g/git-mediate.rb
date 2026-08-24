class GitMediate < Formula
  desc "Utility to help resolve merge conflicts"
  homepage "https://github.com/Peaker/git-mediate"
  url "https://github.com/Peaker/git-mediate/archive/refs/tags/1.2.0.tar.gz"
  sha256 "841f48c18f83f3be05a7227f429310d0ff3fc2275e285b46fc23c38bd7407ac7"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8c13903130eae451fc26489fe0d5649eea73d90e20a179ebf981e8045d78e782"
    sha256 cellar: :any, arm64_sequoia: "b2ac564be2115a343eead38b9f39b50ccb1327cbbade8bb6f27858cae5969883"
    sha256 cellar: :any, arm64_sonoma:  "3469431bc834ffd3ff6debe44fade46b9bc21139d5888eb5677820fef94f74d0"
    sha256 cellar: :any, sonoma:        "41a5cd8f4e1b89da621108410d33fb442aadb4c36af73c0f0d82530b1ff595fd"
    sha256 cellar: :any, arm64_linux:   "c4b7dd5f856589897576c95975b0f844b3511f5d8772c2e83a9752994544c788"
    sha256 cellar: :any, x86_64_linux:  "c227d7594c93ec201e98a6ebb8735114d81720b6926a777f5bcb5fa39d789cf3"
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
