class GitAbsorb < Formula
  desc "Automatic git commit --fixup"
  homepage "https://github.com/tummychow/git-absorb"
  url "https://github.com/tummychow/git-absorb/archive/refs/tags/0.6.15.tar.gz"
  sha256 "630e61a6edf1e244c38145bda98a522217c34d3ab70a3399af1f29f19e7ced26"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "aca945b8aef34abbac4f2c98a725a55bc61963c5b2f05c6ec6036d02deb19a08"
    sha256 cellar: :any,                 arm64_sonoma:   "4ba2cc5db7997e70fe3126dcb72ce6b90ecc448522f84ecf256dbf83aa5b0f03"
    sha256 cellar: :any,                 arm64_ventura:  "3b0d0c694199a5737537e350d1f94a3c5578ad01f37fa606426961d815597a90"
    sha256 cellar: :any,                 arm64_monterey: "58047813577676e3087030dec2bcefa9092585097d206befda82b16d3a01cf65"
    sha256 cellar: :any,                 sonoma:         "646e551cecba255be82b580462b9065fd74fb01cf2c889d2a62306fcd79e523d"
    sha256 cellar: :any,                 ventura:        "518701a348b6de56793560858a17266daf8edd0fca2d87890170e5244109ba67"
    sha256 cellar: :any,                 monterey:       "d9322e1a225a00b72517d640d4afe1998179343908bdbc8f256418049b703b1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94fa2414eb3c9ed63e09ab896610c45810e68d430e236696c6edd10990926008"
  end

  depends_on "pkg-config" => :build
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
