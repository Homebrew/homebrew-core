class GitAbsorb < Formula
  desc "Automatic git commit --fixup"
  homepage "https://github.com/tummychow/git-absorb"
  url "https://github.com/tummychow/git-absorb/archive/0.6.10.tar.gz"
  sha256 "6cc58d2ae50027a212811faa065623666ccb6e8bd933e801319aaf92b164aa0a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0a45b177626286c42073c2a6b4c8ff88b953ff285099f13e77cdf964cd5fb878"
    sha256 cellar: :any,                 arm64_ventura:  "d68270e3d3e72615c006086ced733e72dc8e196225c029e74f552a7441e086b9"
    sha256 cellar: :any,                 arm64_monterey: "06a450082b733db8697d3b90cec6476fd1a8f272ce5145b080f9814aa26cdef5"
    sha256 cellar: :any,                 arm64_big_sur:  "d1e55d7a94961c91d8f90f4c34520b281f67048376d28527286b656813089886"
    sha256 cellar: :any,                 sonoma:         "791e20828d4b84d8d45bca569ec205ad79748937532925802e861c2c1bbe03d5"
    sha256 cellar: :any,                 ventura:        "ce040840fb94cc85825a27001568b3f56e8aa4e4ee0edec977095b256f804ebf"
    sha256 cellar: :any,                 monterey:       "2f3f6c888bedd57186db4dfca8bf2274e1aa2600aad494f84615c045bab83201"
    sha256 cellar: :any,                 big_sur:        "9ec2cdb3f4b7bb545abe2cb6f0ac73b8c9bc51bbf9e7b34094c3b3d5384beb49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca37a602deefa46db849de95f898da60481a4d93095613493b789ffe4fd5c8c4"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.5"

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

    linkage_with_libgit2 = (bin/"git-absorb").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2@1.5"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
