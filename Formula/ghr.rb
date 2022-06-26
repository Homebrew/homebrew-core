class Ghr < Formula
  desc "Upload multiple artifacts to GitHub Release in parallel"
  homepage "https://tcnksm.github.io/ghr"
  url "https://github.com/tcnksm/ghr/archive/v0.14.0.tar.gz"
  sha256 "e48f6080f81960ec12dad0d104cb0afe876134bab862a229c9aed91f9f618c1e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef5d956b276719ddd21fba7bc706aca4a2c339766f035a483b65f4706caa2a96"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04afdc255e1db1bd569f7ca0b8a7b38b1bc5394050c12ab9ab31d1ebde5d1726"
    sha256 cellar: :any_skip_relocation, monterey:       "23f165ccc58dc30062c587043cca2b9044dba8a278f95516711c697451979983"
    sha256 cellar: :any_skip_relocation, big_sur:        "9daff45d2137be191f4906d69385b64afe3f049dc656475585d1c7589a4dcfc1"
    sha256 cellar: :any_skip_relocation, catalina:       "af8668bdf5cf37170d1476fdfeb3df0a81c8dcc83e63f22914d037560a096a37"
    sha256 cellar: :any_skip_relocation, mojave:         "91b37053dae7ad067b16ac4e54a64ce43d71c1c7552b42635012c21a770f4f69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63ac6cdfcd910505644cfc262a1462fa10426c1460a0889924887e85fec69e36"
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
