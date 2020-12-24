class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.24.2.tar.gz"
  sha256 "95f629d57b459a3414af0582c20835edc970ec83a2c791cff97e5b8aac3b7025"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "e215030f08d8728a4a6a32251f5169afcd797aa9da0e35d7f59bf474a33fa8bf" => :big_sur
    sha256 "b4f0f657cd2d0926f9996dbe9f166afc69175c6dc6ed1e5bc9075333190c19d4" => :catalina
    sha256 "cd3ceabafa2dd8a70d4e06f28b2bc119c5a3369e8f984e03141b2316f12ea647" => :mojave
    sha256 "1a63f3be7ce48b8b399ad9ebfad7fe4b6377180b4c938e2c996d27915b00ef2a" => :high_sierra
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
