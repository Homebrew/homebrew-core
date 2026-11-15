class Difi < Formula
  desc "Pixel-perfect terminal diff viewer"
  homepage "https://github.com/xguot/difi"
  url "https://github.com/xguot/difi/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "8c368679e5d4257d6a62e30fc13db3a28a4947a75ba2222ab5990dec5a7be55d"
  license "MIT"
  head "https://github.com/xguot/difi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "05e08897f506d63d27433dcb951393e62ee5bcdf495b8559ea7458cdd732786d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "05e08897f506d63d27433dcb951393e62ee5bcdf495b8559ea7458cdd732786d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "05e08897f506d63d27433dcb951393e62ee5bcdf495b8559ea7458cdd732786d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "42b1d592c50bf899a851499dbf82ae7378bd1d9426602e9ea585392355d2aae9"
    sha256 cellar: :any,                 x86_64_linux:      "23635d82f37634da92eff634f16795e710928a72e51a4341a02f3165dc8b2fbf"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/difi"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/difi -version")

    system "git", "init"
    system "git", "config", "user.email", "test@example.com"
    system "git", "config", "user.name", "Test"

    (testpath/"file.txt").write("one")
    system "git", "add", "file.txt"
    system "git", "commit", "-m", "init"

    File.write(testpath/"file.txt", "two")
    system "git", "commit", "-am", "change"

    output = shell_output("#{bin}/difi --plain HEAD~1")
    assert_match "file.txt", output
  end
end
