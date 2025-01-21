class GitAbsorb < Formula
  desc "Automatic git commit --fixup"
  homepage "https://github.com/tummychow/git-absorb"
  url "https://github.com/tummychow/git-absorb/archive/refs/tags/0.6.17.tar.gz"
  sha256 "512ef2bf0e642f8c34eb56aad657413bd9e04595e3bc4650ecf1c0799f148ca4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bb985890d415ff167d823f5ecb8a8e627b97375b81efb58fc00db2995dc806b2"
    sha256 cellar: :any,                 arm64_sonoma:  "4b43c763348b5beb746a35baa22ff81511e89338669a46f5daf979ec30383267"
    sha256 cellar: :any,                 arm64_ventura: "0fa5ccdc1815c2fed9505950968e1075ee971d4f158b087b4d22f1bd797b1734"
    sha256 cellar: :any,                 sonoma:        "1bd3b24e9b32f49351555e3e8bea57fcc868a475243df29082f07899a87d3a02"
    sha256 cellar: :any,                 ventura:       "74aa1215fca2e8df5a019b03ad8b917bc9bd73d24b1be84e9d129054922a3cc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e75f77c1f10cefb7a8400671d7d2eb307ea41d4d36e0aeb7f71c266e0d1590c3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

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

    linkage_with_libgit2 = (bin/"git-absorb").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
