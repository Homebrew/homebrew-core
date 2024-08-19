class GitMediate < Formula
  desc "Utility to help resolve merge conflicts"
  homepage "https://github.com/Peaker/git-mediate"
  url "https://github.com/Peaker/git-mediate/archive/refs/tags/1.0.9.tar.gz"
  sha256 "ed9b4f5f1ccc295e69d5a368b1b5436968e2290b8e1792a768c0cfae7f91fefb"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "71de13c47e25de264c51721ea9bd639853ac2e27d37cb4b287ed82720a375c29"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a7db9e71a7784d5bdd43d615c32705edf5c13db7478cf21175839c8a62245db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8808be675fcc86cbbe5008f61d1c612177a112c7cc84e28c449758f51e060e39"
    sha256 cellar: :any_skip_relocation, sonoma:         "a540d882dd95a4cb74294c8dc89d14733c91a408bc5aef8b18685cbd8ab5e3e5"
    sha256 cellar: :any_skip_relocation, ventura:        "716b6e60cc97f262a16ddeedef3331420235505513b8ef4fde017eb673aeac1a"
    sha256 cellar: :any_skip_relocation, monterey:       "3822dd197c6bb981da0880319c07e9c93ced515a0eef49de7aecaf72081fdd83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0086a8e11d14f3f9b29e0d4972c61ab5daa2a7b357fcc54c29dfdf7699c436b6"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build

  def install
    system "stack", "install", "--system-ghc", "--no-install-ghc", "--skip-ghc-check", "--local-bin-path=#{bin}"
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
