class GitAbsorb < Formula
  desc "Automatic git commit --fixup"
  homepage "https://github.com/tummychow/git-absorb"
  url "https://github.com/tummychow/git-absorb/archive/refs/tags/0.9.0.tar.gz"
  sha256 "a0f74e6306d7fbd746d2b4a6856621d46a7f82e3e88b6bb8b6fc0480cf811f53"
  license "BSD-3-Clause"
  head "https://github.com/tummychow/git-absorb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "15d25d50f77a146d40e0d2d71fa977f77687bb290e1e42f680edee5c332683b9"
    sha256 cellar: :any,                 arm64_sequoia: "3705ab0482910af6744073aa1eafd7aa0010c02d77249b2419ef356538653dcb"
    sha256 cellar: :any,                 arm64_sonoma:  "e408a461a67c6334533ef540f82caea09c31714aca72d404c9be97325754af4f"
    sha256 cellar: :any,                 sonoma:        "ad387b6822e19ed2cc5d0947ab764639fcf7557660383d57e4e0fc17353731fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b0717a00ef65e265f27f90fbb989ce12df1449dc51854166d9be02f09f87adc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fcd6d7cfdce2f15b53389137242a03e7cef8c6bb8927640527db2375a006b20"
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

    require "utils/linkage"
    library = Formula["libgit2"].opt_lib/shared_library("libgit2")
    assert Utils.binary_linked_to_library?(bin/"git-absorb", library),
           "No linkage with #{library.basename}! Cargo is likely using a vendored version."
  end
end
