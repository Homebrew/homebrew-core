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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "6deb4776ef5eb24799282fc8b4489e643c97c8d56303287763626f350ed79cd1"
    sha256 cellar: :any,                 arm64_sequoia: "835c61bf47166e53349a684b49dffc494a454da85ac7f246cc86274490614219"
    sha256 cellar: :any,                 arm64_sonoma:  "84dc9fc37498504ad7d7d1e9ddb032acbedd7402f97dfbbc02856753815b6ee1"
    sha256 cellar: :any,                 sonoma:        "39e883fcac9342280b03218a663e61ce29ca8854e036c270a2e7dc1702d84d74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc6bb58f3af6b57b89d172f05cc6c16c8c3f21d295a3912a6068013906b82afd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60f1a23c2048c4581dfd226e3bc7bbeb83f0a54d33cff7e1c0d3847fc2e2b729"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
