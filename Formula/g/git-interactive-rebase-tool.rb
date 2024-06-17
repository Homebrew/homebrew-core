class GitInteractiveRebaseTool < Formula
  desc "Native sequence editor for Git interactive rebase"
  homepage "https://gitrebasetool.mitmaro.ca/"
  url "https://github.com/MitMaro/git-interactive-rebase-tool/archive/refs/tags/2.4.0.tar.gz"
  sha256 "25d76f5565d2283f320491fa7d7fe2fd12ef2664fa29fb7e332e048e687b8178"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8429e444bd9bed7cabacce6b949e3422d2e35b5d092020773154370aefb0e7ac"
    sha256 cellar: :any,                 arm64_ventura:  "3f072ba39641bfd213c9fd9145f63375a7d101cddcdea4adc28234c53505c97f"
    sha256 cellar: :any,                 arm64_monterey: "3d7070c4913492785ca75a0a17b86b13136f9481b05941a950b51445120e1bd8"
    sha256 cellar: :any,                 sonoma:         "785162ad5c56856a764aa4b71de7bd28ab19339d27a06b9abfd361733b277896"
    sha256 cellar: :any,                 ventura:        "157a34883bc15a1ebc4e59bfea8eb21f680100cad5f8cacda7cc93cec24580aa"
    sha256 cellar: :any,                 monterey:       "7c6147296984de54844c4eaaf4afed7a7c0df23ddd4dbcd0f22bf5633ef97d23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c96a2122bbaa4a975e2bc8710934eae851351a885dbd5b2fc3af34cdf7c1439f"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

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
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
    ].each do |library|
      assert check_binary_linkage(bin/"interactive-rebase-tool", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
