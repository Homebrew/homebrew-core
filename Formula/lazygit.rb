class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.16.2.tar.gz"
  sha256 "76c043e59afc403d7353cdb188ac6850ce4c4125412e291240c787b0187e71c6"

  bottle do
    cellar :any_skip_relocation
    sha256 "6d7a285accad08d22ffe3cf34f552ce47c2c320805bb6fc4a956e39e156dfddb" => :catalina
    sha256 "fa87fdc8949faabbfb6cdaa553d3c4465119444d797335a4519350d11c2e4876" => :mojave
    sha256 "f64cfa2998a5f9cc072906b0cafba468a14d202875bb5322ac79cc99deb3628a" => :high_sierra
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
