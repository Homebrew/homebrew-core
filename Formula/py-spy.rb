class PySpy < Formula
  desc "Sampling profiler for Python programs"
  homepage "https://github.com/benfred/py-spy"
  url "https://github.com/benfred/py-spy/archive/refs/tags/v0.3.9.tar.gz"
  sha256 "1e3d240def5357e6096a3e8a37a60bbe3c28515e4590b752109510f35d237170"
  license "MIT"
  head "https://github.com/benfred/py-spy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "22121c8eaec4a7cd913ae2add7287df36ad0e9a32f8f3a141faeef12401672cc"
    sha256 cellar: :any_skip_relocation, big_sur:       "4dffb9d38caafb69e1bb3f3183a668102679b17824205a6a54e55966713cfcd5"
    sha256 cellar: :any_skip_relocation, catalina:      "915ac43c4c40dbac5d0abf7c014a335264d0d34e1d36e6f5eefc02147a296375"
    sha256 cellar: :any_skip_relocation, mojave:        "58015a69ab226cdbb2a2a28d9094cd9b90c23743aee394566e86c63f3cbc128c"
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
