class GitAbsorb < Formula
  desc "Automatic git commit --fixup"
  homepage "https://github.com/tummychow/git-absorb"
  url "https://github.com/tummychow/git-absorb/archive/refs/tags/0.6.12.tar.gz"
  sha256 "88a64712bcb4885a65984359c783e7f16b76fe4ca4ccd339d0c2d83139d0428b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "132f1bb9c25a7d6846e5750ca1424c921676bd89bccd479f95fa70d63666bba8"
    sha256 cellar: :any,                 arm64_ventura:  "1209e6679448586b5dbe805d3ddeffb25db62c12ad39ea3cb4c27b0b8685be79"
    sha256 cellar: :any,                 arm64_monterey: "e043101eb1548f3ae582afba7221d796d09a8b4ea563e2241fcb0e2f8cc72483"
    sha256 cellar: :any,                 sonoma:         "ee0017cb0f5fcb667546a586433ee1dfcac5ddc68e304faa13baae0931f51827"
    sha256 cellar: :any,                 ventura:        "e98d15fae9087c6275bd329d23306d07924c471977b811f8c7d6debffef5259d"
    sha256 cellar: :any,                 monterey:       "c729abf17834d844e7a188a9101e19b652925b1e54cf90cca0bc3a9a08b6d879"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "033a4edd4d671b5a349ca17c918d9cda24328a8f3c14680f3ff969112e703a51"
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
