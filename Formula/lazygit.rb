class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.14.3.tar.gz"
  sha256 "9ff8672aff431f5ccd943cc2a87877950b1efd7e9987a3c024c9b626a2a7ee81"

  bottle do
    cellar :any_skip_relocation
    sha256 "39f1a2f118e474da627b6d8835a99694f629d163669a5d73d36de0ebb01db194" => :catalina
    sha256 "38aaf8830cab246cb3b4a765d04b48db47dd2a6cf19fe0f317e79e87becc7f8b" => :mojave
    sha256 "e5978e9cb98b9d8f6afde7cc2f3c99222b28ad832529cf534c7630b8185687a1" => :high_sierra
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
