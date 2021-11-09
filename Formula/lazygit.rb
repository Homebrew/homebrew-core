class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/v0.31.3.tar.gz"
  sha256 "7a9fcb0c5f1edf025d1e1f5fb21099770e0de7ed424af62e133bd9d4afffdc35"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "982fb3306ac7df0c4ebab398f56d9ea032e8f5b34386ca28d5eab0f14171646d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc90dc6cf45d33fd11fbe5bb8d2131608701aad5220bff1d4c3735c16b91d06d"
    sha256 cellar: :any_skip_relocation, monterey:       "421c6ba6905839aec280907602b669d5f4d492eb48922d33c975e52c3058adcc"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6e438306b0b3f70fc1914b4e1fefb9a09f139c41cd9146c90e686d8e40ebc5f"
    sha256 cellar: :any_skip_relocation, catalina:       "28ef7a8965d31b39a2960ff13596e4c1c8c8ab33113d5094afbd0e65c1a39adc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab1b126bac2135036c2ff36cca40216bf7fa0a96b0702f19f3babe267dd33507"
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
