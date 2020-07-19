class GitInteractiveRebaseTool < Formula
  desc "Native sequence editor for Git interactive rebase"
  homepage "https://gitrebasetool.mitmaro.ca/"
  url "https://github.com/MitMaro/git-interactive-rebase-tool/archive/1.2.1.tar.gz"
  sha256 "8df32f209d481580c3365a065882e40343ecc42d9e4ed593838092bb6746a197"
  license "GPL-3.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "ab2feae40a1c22695f88383fc0d25bd1ce90499cf74004719fbaf7540a673f09" => :catalina
    sha256 "50a7e6d5e3b6e0cdb75f9dd83fde8c9d473a632c8f22f575591fe4b5469a19bf" => :mojave
    sha256 "530ae677663e9773d05a17878a1e28e91e8751d9b9ac8cffdb0acaad7a7d1e8b" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
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
