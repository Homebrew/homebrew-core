class Ghr < Formula
  desc "Upload multiple artifacts to GitHub Release in parallel"
  homepage "https://tcnksm.github.io/ghr"
  url "https://github.com/tcnksm/ghr/archive/v0.16.0.tar.gz"
  sha256 "c2b1f0a25b3e0b9016418c125441f16615387e32bce5c56049064deffbe1b1c9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0382889177cd5c07581d4a2d0359187a72c0941533bcd4454116ed9129ee35d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "723f6a46ed525ca4fd06386d63d7ea6e8818323c68260d7c0820edce3385917e"
    sha256 cellar: :any_skip_relocation, monterey:       "23eeea8b179a396664221f26d037cba38dad060aa4d137af51e4e4d70169e2c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "d021279dc3e1bcbdcdfbf786639c67d9908f50dcf082198fbd7f1b3674467399"
    sha256 cellar: :any_skip_relocation, catalina:       "08672e3a3aa193fa07716995d2d2d4803d8deb83e430cc5d4e47634d65b0e2fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9156b8ae869f2f07f35ac086f93b52e2e50d504d2329c5bd505e4765967f708"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["GITHUB_TOKEN"] = nil
    args = "-username testbot -repository #{testpath} v#{version} #{Dir.pwd}"
    assert_includes "token not found", shell_output("#{bin}/ghr #{args}", 15)
  end
end
