class GitAbsorb < Formula
  desc "Automatic git commit --fixup"
  homepage "https://github.com/tummychow/git-absorb"
  url "https://github.com/tummychow/git-absorb/archive/refs/tags/0.6.13.tar.gz"
  sha256 "5646857dd764d0a486405e777b3ec4e919511abc96bd0e02e71ec9e94d151115"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "df731f48f4a4459d9ba90b72ca47e0f698b82fcd69370f71df9ee2967dc7e6ea"
    sha256 cellar: :any,                 arm64_ventura:  "73602d8efc5f811b7acbeb12177d76a0e4fe96e52cd96e43a72da20916935e8a"
    sha256 cellar: :any,                 arm64_monterey: "edb8e66049b0dcc8de679f131bcf68008910d120229a2f54850b42f040a9600b"
    sha256 cellar: :any,                 sonoma:         "1592f26901975188f29885e8d0dd13b048d6b7727ed1cc0bc615326c3918a652"
    sha256 cellar: :any,                 ventura:        "9cf1d534c7e6c968b5091ce9a328a2bb061678e65690e749886468c4cb064a17"
    sha256 cellar: :any,                 monterey:       "cf003ab7066c07b92b2b3dcd75c6b41778f5efc80494b4d92d35f71e1348b54d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "713a96e6da4edc29aaa8632d87f805c9f58d695f26217c7adc9212874fb3cd2a"
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
