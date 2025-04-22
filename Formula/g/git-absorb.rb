class GitAbsorb < Formula
  desc "Automatic git commit --fixup"
  homepage "https://github.com/tummychow/git-absorb"
  url "https://github.com/tummychow/git-absorb/archive/refs/tags/0.7.0.tar.gz"
  sha256 "65f5b80bcb726a0c40eeda94ccb47fce7f3fc4ed16021465196a37b907083eb8"
  license "BSD-3-Clause"
  head "https://github.com/tummychow/git-absorb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2a0a02563c008f357386f98611bd4fc620d9cde08ef34601e8153d114ba41bbb"
    sha256 cellar: :any,                 arm64_sonoma:  "67c6e9f547b87f4eb0993fc813746d0a352b1ff6077a59f25e8ac95f301d7e6f"
    sha256 cellar: :any,                 arm64_ventura: "2460eca14e40946b5d739f9b89b9de70acbd87b7f0849e464a60e58b6de7daed"
    sha256 cellar: :any,                 sonoma:        "ad181f87d1bb47476db2e533b3b03d4c6f9e8c9a2aa9db914aa7df416259d5a4"
    sha256 cellar: :any,                 ventura:       "6a8785c9939b7fb75b2595ea5f3d1dffcb2b6dde34ceb58572f68ca25fb73974"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe48890abe6494521b53581355c3a5ae1fce29de4982133250ae43aaaf376c4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1955fcb9602e4dab7e6ac246f16337c6b4565cc5d0a5f8abca1d0542d6f10248"
  end

  depends_on "asciidoctor" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"git-absorb", "--gen-completions")
    cd "Documentation" do
      system "asciidoctor", "-b", "manpage", "git-absorb.adoc"
      man1.install "git-absorb.1"
    end
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
