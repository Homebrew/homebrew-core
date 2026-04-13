class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://github.com/njbrake/agent-of-empires/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "f3179f625264f80ba86e46be6c7303717067430b3a144ac05cf7def726dc5098"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "fe0900b74c1e27d6b24dce854a1c62f7ae85832075314f8d2afa770e2ced4b4c"
    sha256 cellar: :any,                 arm64_sequoia: "7dc0f5e559238bf8591349ae6d38d8f2237927668fd7686967543d615e02741f"
    sha256 cellar: :any,                 arm64_sonoma:  "e95ba46ad49cda11a1f870f649457cc99b17116cae3a8fcfbc3dc1370fcda8ea"
    sha256 cellar: :any,                 sonoma:        "575fcea748d5cde43d9a3a1ec98a49bacd89303cce43034eb8850a048f87d3f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b7fc8f8bbd11044dc9a0d964d744516c0c1b26a737be93ed240ee0f779cf983"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31aa2fe72a99db65237104460835cddf816943b10cd66df2d080b2475ce0b964"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "tmux"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"aoe", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aoe --version")

    system bin/"aoe", "init", testpath
    assert_match "Agent of Empires", (testpath/".agent-of-empires/config.toml").read

    output = shell_output("#{bin}/aoe init #{testpath} 2>&1", 1)
    assert_match "already exists", output

    status = JSON.parse(shell_output("#{bin}/aoe status --json"))
    assert_equal 0, status["total"]
  end
end
