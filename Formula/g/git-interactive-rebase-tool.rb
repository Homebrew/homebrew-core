class GitInteractiveRebaseTool < Formula
  desc "Native sequence editor for Git interactive rebase"
  homepage "https://gitrebasetool.mitmaro.ca/"
  url "https://github.com/MitMaro/git-interactive-rebase-tool/archive/refs/tags/2.4.1.tar.gz"
  sha256 "0b1ba68a1ba1548f44209ce1228d17d6d5768d72ffa991909771df8e9d42d70d"
  license "GPL-3.0-or-later"
  revision 4

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "59edafac4ddba19f47cd31f4c09274eecd241460d37336a094137b4d78d7baf9"
    sha256 cellar: :any,                 arm64_sequoia: "be79dedf848897cbce256b691a0baf54fff8ae7138c674a8aac9f0818c6a5eae"
    sha256 cellar: :any,                 arm64_sonoma:  "8290dbb2de4e0273fc9bf1de29cb27bc564a1ad921c024fcc9bf80911550eea4"
    sha256 cellar: :any,                 arm64_ventura: "a8d4f2130634d33aff7b2a4ae0dbce99d783cbb07659ec5b40ce4e51f9661852"
    sha256 cellar: :any,                 sonoma:        "1057b8baf1e744c13106e99148d3157483d33d7052d6c5cf31e07a8ced6941a4"
    sha256 cellar: :any,                 ventura:       "14d3693aeb6937371f12b737ea2d168843b6c3bd5d08ff4a439603afe4f53a7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03172eaa8df62e5a3d3e30b250cf5008c9416738541198ac25380bca13cb8054"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a88b6633a37b3db5fceb6ff1dd10dfb3c8c8131d0f0f940fa166d92bddaf7520"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  uses_from_macos "zlib"

  # support libgit2 1.9, upstream pr ref, https://github.com/MitMaro/git-interactive-rebase-tool/pull/948
  patch do
    url "https://github.com/MitMaro/git-interactive-rebase-tool/commit/f3193b3faae665605d6bac4c1bafa798d3d241ae.patch?full_index=1"
    sha256 "32c6cc976407c0d2f41e434e35274f86d64b8b396ed18927c833af656551ebd3"
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    require "io/console"
    require "utils/linkage"

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
      assert Utils.binary_linked_to_library?(bin/"interactive-rebase-tool", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
