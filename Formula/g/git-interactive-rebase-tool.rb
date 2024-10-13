class GitInteractiveRebaseTool < Formula
  desc "Native sequence editor for Git interactive rebase"
  homepage "https://gitrebasetool.mitmaro.ca/"
  url "https://github.com/MitMaro/git-interactive-rebase-tool/archive/refs/tags/2.4.1.tar.gz"
  sha256 "0b1ba68a1ba1548f44209ce1228d17d6d5768d72ffa991909771df8e9d42d70d"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "9db02f1036165ea5581b513a08f73988438cf04523585b2b6bba5b02568fe123"
    sha256 cellar: :any,                 arm64_sonoma:   "fb5993c4312324326b25f1e2209b6fcbe88fc98352db69fdb07c0b5c63e42873"
    sha256 cellar: :any,                 arm64_ventura:  "0bf45047f460751efed83d895546c79188af0933cba013160a8a0fe0cedb7b89"
    sha256 cellar: :any,                 arm64_monterey: "72a6adb852a9d40a838a9136717148b2aaf1e70f832e5edc599d33f87fd77149"
    sha256 cellar: :any,                 sonoma:         "fca7280d997fbac58b67ad6b55e627805353ec814fd0a23fa3883a699def7326"
    sha256 cellar: :any,                 ventura:        "8f8ffe5ca81753b46ff1df663fe9219baa5a9e331d3abd29f91af0f97a077a95"
    sha256 cellar: :any,                 monterey:       "8512328d56cf54e7f7c712b985b84ee6267df174eb45e514f8da300f312a0905"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7aa1b32fbfe987e86fdd9aa2a914c14a041341b9a7ce781555b68ca325b2e31"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.7"

  uses_from_macos "zlib"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    require "pty"
    require "io/console"

    mkdir testpath/"repo" do
      system "git", "init"
    end

    (testpath/"repo/.git/rebase-merge/git-rebase-todo").write <<~EOS
      noop
    EOS

    expected_git_rebase_todo = <<~EOS
      noop
    EOS

    env = { "GIT_DIR" => testpath/"repo/.git/" }
    executable = bin/"interactive-rebase-tool"
    todo_file = testpath/"repo/.git/rebase-merge/git-rebase-todo"

    _, _, pid = PTY.spawn(env, executable, todo_file)
    Process.wait(pid)

    assert_equal 0, $CHILD_STATUS.exitstatus
    assert_equal expected_git_rebase_todo, todo_file.read

    [
      Formula["libgit2@1.7"].opt_lib/shared_library("libgit2"),
    ].each do |library|
      assert check_binary_linkage(bin/"interactive-rebase-tool", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
