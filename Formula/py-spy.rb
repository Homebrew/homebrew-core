class PySpy < Formula
  desc "Sampling profiler for Python programs"
  homepage "https://github.com/benfred/py-spy"
  url "https://github.com/benfred/py-spy/archive/refs/tags/v0.3.12.tar.gz"
  sha256 "6a4b0537e0bf9cf40fc4557931955222a25db01c110309d0b642dd28211bffeb"
  license "MIT"
  head "https://github.com/benfred/py-spy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e173344a61c94b2b47230bdbd60b28485a66101a80e74e138b291c1d77db15a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f205ddc3f08b11e91ae023cd699153bab4f0f5ec500014b352fc46b76e2e1f64"
    sha256 cellar: :any_skip_relocation, monterey:       "45b42cedd108860fc73371420c2c98f49c9accc61b18efd7fe6fd223919808a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "d385fca448f241602624f98ba5af909ba0d8142a3f7587ca460240d224e63324"
    sha256 cellar: :any_skip_relocation, catalina:       "fd5f0a7e3a7bc3b10840b7c290571f6a5901ed51c8facc561e0659dc938ae377"
  end

  depends_on "rust" => :build
  depends_on "python@3.10" => :test

  on_linux do
    depends_on "libunwind"
  end

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
    python = Formula["python@3.10"].opt_bin/"python3"
    output = shell_output("#{bin}/py-spy record #{python} 2>&1", 1)
    assert_match "Try running again with elevated permissions by going", output
  end
end
