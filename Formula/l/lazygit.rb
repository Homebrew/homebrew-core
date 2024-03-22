class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/refs/tags/v0.40.2.tar.gz"
  sha256 "146bd63995fcf2f2373bbc2143b3565b7a2be49a1d4e385496265ac0f69e4128"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "43f8cb9c06f621ac78a4bf6870742b91d9e96cf8db85da0957f8a05dc7154dcf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e398249fa9a80170dc15f8673d14d9df9448784cdd73e0ad88182a5dd58f35bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e398249fa9a80170dc15f8673d14d9df9448784cdd73e0ad88182a5dd58f35bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e398249fa9a80170dc15f8673d14d9df9448784cdd73e0ad88182a5dd58f35bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "0fb3ed994940307ab9c166f4bbbbfe348c87fea4ce67569a6b2ad0511ae2b7a8"
    sha256 cellar: :any_skip_relocation, ventura:        "cbbc73dd93fb9c0c6debc600f943d731bc97638ba4446ead82b310f5c656adb2"
    sha256 cellar: :any_skip_relocation, monterey:       "cbbc73dd93fb9c0c6debc600f943d731bc97638ba4446ead82b310f5c656adb2"
    sha256 cellar: :any_skip_relocation, big_sur:        "cbbc73dd93fb9c0c6debc600f943d731bc97638ba4446ead82b310f5c656adb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d0146819f9fdddb625047d14d592d5cbb8fa908ad96c70ef1177239ccc30b0e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -X main.buildSource=homebrew"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
  end

  # lazygit is a terminal GUI, but it can be run in 'client mode' to do certain tasks
  test do
    (testpath/"git-rebase-todo").write ""
    ENV["LAZYGIT_DAEMON_KIND"] = "2" # cherry pick commit
    ENV["LAZYGIT_DAEMON_INSTRUCTION"] = "{\"Todo\":\"pick 401a0c3\"}"
    system "#{bin}/lazygit", "git-rebase-todo"
    assert_match "pick 401a0c3", (testpath/"git-rebase-todo").read
  end
end
