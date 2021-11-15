class PySpy < Formula
  desc "Sampling profiler for Python programs"
  homepage "https://github.com/benfred/py-spy"
  url "https://github.com/benfred/py-spy/archive/refs/tags/v0.3.11.tar.gz"
  sha256 "094cfb80e2c099763453fc39cfa9c46cfa423afa858268c6a7bc0d867763b014"
  license "MIT"
  head "https://github.com/benfred/py-spy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "117cc4ae799abeda0ec934378e287d78196c66da8219843266336519f5252174"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1951839640b1aa3d4deb01f27fd0130e5c9e49227a3997cad3b0e622c79b8cf3"
    sha256 cellar: :any_skip_relocation, monterey:       "05f6c44c4453d888b149f3fa2009c1c3b31d3073c2980632ebaf7e1f2289832e"
    sha256 cellar: :any_skip_relocation, big_sur:        "651aeae6101063deed04c2219abc9068444f24eb7640c3db9d22d7edab8b3e79"
    sha256 cellar: :any_skip_relocation, catalina:       "1792e2f649b4d6d8fe9fc1151e1d70815b43775b3ebf96323e704c1769449121"
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
