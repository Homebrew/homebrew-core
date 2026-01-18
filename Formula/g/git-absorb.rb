class GitAbsorb < Formula
  desc "Automatic git commit --fixup"
  homepage "https://github.com/tummychow/git-absorb"
  url "https://github.com/tummychow/git-absorb/archive/refs/tags/0.8.0.tar.gz"
  sha256 "9ed6fef801fbfeb7110744cac38ae5b3387d8832749ae20077b9139d032211f1"
  license "BSD-3-Clause"
  head "https://github.com/tummychow/git-absorb.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eabe1a7f9c54ac0583f8eac709d2fa4fbb0f2ab54e34eeb46f84c6788d8be95a"
    sha256 cellar: :any,                 arm64_sequoia: "bbfc1e3dfbfcda686df0aea15468eec4549ea36fd82454397e5b549e8f867b42"
    sha256 cellar: :any,                 arm64_sonoma:  "341871005558c9ee562ce65d7937664279a6a87b8ed4fec08706a4a75b8ebf00"
    sha256 cellar: :any,                 arm64_ventura: "775f14a76615d9432e16ceb484d8c2dc28e5f019fe054563118df025caee269e"
    sha256 cellar: :any,                 sonoma:        "b8dbc17ae633c630a3ce42743a56d74d5a60b92f6374f7dc9c44f173d07e8ff3"
    sha256 cellar: :any,                 ventura:       "41d7ac555ada72c4c06ba94112bd306a61a81a267d441b1eabb04907a61c5f22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25ad1bee716eea6cc6b0dc91a5cbd1caf3fe8c7bfdaee87b56e1656b5811ccaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21f8b05c5d835e0582690c4dc7d5b6fc8cbfe231022ae594c03bcd9d592fcb73"
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
