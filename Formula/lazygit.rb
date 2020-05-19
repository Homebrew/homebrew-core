class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.20.4.tar.gz"
  sha256 "8af316bf9d0916e8b19ce590a80664314a38652af9ef115083686bc9720fa7b9"

  bottle do
    cellar :any_skip_relocation
    sha256 "152cb8a9b65eecef1eb283b0ca1ddf1503a08126cdbbb2c3491ebbbb3211e6fd" => :catalina
    sha256 "b09cc1650c5f32732b1d700cbbfba8eda3f86ec8a6b6cf1f6663e2581340d37a" => :mojave
    sha256 "af7b9c00fb1586593350b06cec79a447b4070da4e0d4dd386664a9a786928bbd" => :high_sierra
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
