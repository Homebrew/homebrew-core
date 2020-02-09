class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.14.2.tar.gz"
  sha256 "f377aed6b5e51b6885544a012062ba863d3599e1dab2e7928bea7880c2888e7f"

  bottle do
    cellar :any_skip_relocation
    sha256 "b35e098991d22eb8b9d9e954d934646fb37c106c3f6c938dc0dd66d6fb56857d" => :catalina
    sha256 "a52e3a0cae76b543beda342e15e2db3a57e00a36cef0980e7d4b2c462e287e57" => :mojave
    sha256 "22392e8a69b86048b1803e7111b840ff68dd884ad65ad2259371109565799349" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-o", bin/"lazygit",
      "-ldflags", "-X main.version=#{version} -X main.buildSource=homebrew"
  end

  # lazygit is a terminal GUI, but it can be run in 'client mode' for example to write to git's todo file
  test do
    (testpath/"git-rebase-todo").write ""
    ENV["LAZYGIT_CLIENT_COMMAND"] = "INTERACTIVE_REBASE"
    ENV["LAZYGIT_REBASE_TODO"] = "foo"
    system "#{bin}/lazygit", "git-rebase-todo"
    assert_match "foo", (testpath/"git-rebase-todo").read
  end
end
