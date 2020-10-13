class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.23.2.tar.gz"
  sha256 "a541756a28d00ffc1fc9ba385c06b91fcc51df815a2919f7072873c969b2034c"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "57d19d6147d23d94cee2ed38272da6663aa253ce02d72215cacb17a39d8e01f8" => :catalina
    sha256 "b7969c3b049230b315a1114b1c49fb3cd339ec2aedfe2aebaab5b9922af93866" => :mojave
    sha256 "fcd14cd2ffcbb86a14ff4216a297ed017657f1e5ac4375cda51077f45bd0fc51" => :high_sierra
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
