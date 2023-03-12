class GitInteractiveRebaseTool < Formula
  desc "Native sequence editor for Git interactive rebase"
  homepage "https://gitrebasetool.mitmaro.ca/"
  url "https://github.com/MitMaro/git-interactive-rebase-tool/archive/2.2.1.tar.gz"
  sha256 "86f262e6607ac0bf5cee22ca1b333cf9f827e09d3257658d525a518aa785ca7c"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "1ac575cd58d30c97816c09ba486d3fa1d2057dbafb79d55d9971215260d39480"
    sha256 cellar: :any,                 arm64_monterey: "451279b234f20f109fecc9be99dfbcb15a8986406976d321c27a400880bc87cc"
    sha256 cellar: :any,                 arm64_big_sur:  "80d377b60f769fa652d925fcd479e7be55bf6010474ba2c25da7e76fb4d56625"
    sha256 cellar: :any,                 ventura:        "e89b99d8937eec1932f5416d573c5ae708d6b0a4b43d2063b4dda2a75ee60001"
    sha256 cellar: :any,                 monterey:       "28bd974a0057f0e47e65a6d890e30eecba9f4a8cdb52ff3c2b4c2b5463bc6bc8"
    sha256 cellar: :any,                 big_sur:        "4f41d96eed608acf08a0c35fb541317567b2b2ccd756f12fd284fcc6780abe53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2af72c4cc5358d03fa418bcec51f14c468c9864dd7bb3769585d98fc6e793fb"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  def install
    system "cargo", "install", *std_cargo_args
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

    linkage_with_libgit2 = executable.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end

    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
