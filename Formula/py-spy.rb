class PySpy < Formula
  desc "Sampling profiler for Python programs"
  homepage "https://github.com/benfred/py-spy"
  url "https://github.com/benfred/py-spy/archive/refs/tags/v0.3.9.tar.gz"
  sha256 "1e3d240def5357e6096a3e8a37a60bbe3c28515e4590b752109510f35d237170"
  license "MIT"
  head "https://github.com/benfred/py-spy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6a2e9bd709864ff5c99ac64d761a8bc50afce0222717c78b43135da05519449c"
    sha256 cellar: :any_skip_relocation, big_sur:       "4a3a7ff1984e412ec62dc5f00c4699cfd33eb30c6d1711055be9428617a72748"
    sha256 cellar: :any_skip_relocation, catalina:      "8cd7695d35222cb75c59ffff972eac470acc332a815c63ce16cc2eb3cc4559af"
    sha256 cellar: :any_skip_relocation, mojave:        "dfb3079b96434ce14dd438a69830b31a27d9a0b7e6875df861b47dfbd9f9c6ca"
  end

  depends_on "rust" => :build
  depends_on "python@3.9" => :test

  def install
    system "cargo", "install", *std_cargo_args

    bash_output = Utils.safe_popen_read(bin/"py-spy", "completions", "bash")
    (bash_completion/"py-spy").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"py-spy", "completions", "zsh")
    (zsh_completion/"_py-spy").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"py-spy", "completions", "fish")
    (fish_completion/"py-spy.fish").write fish_output
  end

  test do
    output = shell_output("#{bin}/py-spy record python3.9 2>&1", 1)
    assert_match "This program requires root", output
  end
end
