class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.29.tar.gz"
  sha256 "f25de2ddab99d2ea06aae87e0be6365033b2ceb8efe94807c8b074884d5e8e38"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d28070bbad3a1495a8e95d3c386a9453874a567587d48ef4d7ef2b004abb429c"
    sha256 cellar: :any_skip_relocation, big_sur:       "e808d8df5c56b02249ef4dc1d73352ce68ca034df107065c2f799c679772ab3d"
    sha256 cellar: :any_skip_relocation, catalina:      "f1346a223ccb8eccefb39c26b7adea7f6146ecd01421ede3ab91d5fdd5e5fdcb"
    sha256 cellar: :any_skip_relocation, mojave:        "40dd9068a4cdf1bb9c791a41101df05f4b7ab6ea516a68469016aadc22d34952"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3398e3d704d89f92b3d1da5e3eea917054a670e643137ac22793ba4d234b7c5"
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
