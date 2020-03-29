class InteractiveRebaseTool < Formula
  desc "Native sequence editor for Git interactive rebase"
  homepage "https://gitrebasetool.mitmaro.ca/"
  url "https://github.com/MitMaro/git-interactive-rebase-tool/archive/1.2.1.tar.gz"
  sha256 "8df32f209d481580c3365a065882e40343ecc42d9e4ed593838092bb6746a197"

  bottle do
    cellar :any_skip_relocation
    sha256 "2a8d8d62c2b236884b25b0c43bfda93365501a80f807cabb071c7a682a2ea86b" => :catalina
    sha256 "5be78d2011eb211939a6d4632f279477315c0bffd321c1aa303910756e966a48" => :mojave
    sha256 "d28ef2f9af69ce2374eae1ad39591a575b5bc743e208b2cb023b8b432a4a231c" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    require "pty" # required for interactivity
    mkdir testpath/"repo" do
      system "git", "init"
      touch "FILE1"
      system "git", "add", "FILE1"
      system "git", "commit", "--date='2005-04-07T22:13:13-3:30'",
                              "--author='Test <test@example.com>'",
                              "--message='File 1'"
      touch "FILE2"
      system "git", "add", "FILE2"
      system "git", "commit", "--date='2005-04-07T22:13:13-3:30'",
                              "--author='Test <test@example.com>'",
                              "--message='File 2'"
    end

    (testpath/"repo/.git/rebase-merge/git-rebase-todo").write <<~EOS
      pick be5eaa0 File 1
      pick 32bd1bb File 2
    EOS

    expected_git_rebase_todo = <<~EOS
      drop be5eaa0 File 1
      pick 32bd1bb File 2
    EOS

    env = { "GIT_DIR" => testpath/"repo/.git/" }
    executable = bin/"interactive-rebase-tool"
    file = testpath/"repo/.git/rebase-merge/git-rebase-todo"
    PTY.spawn(env, executable, file) do |stdout, stdin, _pid|
      # simulate user input
      stdin.putc "d"
      stdin.putc "W"
      stdout.read
    end

    assert_equal expected_git_rebase_todo, (testpath/"repo/.git/rebase-merge/git-rebase-todo").read
  end
end
