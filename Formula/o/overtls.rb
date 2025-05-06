class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https://github.com/ShadowsocksR-Live/overtls"
  url "https://github.com/ShadowsocksR-Live/overtls/archive/refs/tags/v0.2.42.tar.gz"
  sha256 "28beb29bb65a054890da817112ac670ce054da1de182bffbc2150c17f4b1a806"
  license "MIT"
  head "https://github.com/ShadowsocksR-Live/overtls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3d4bd3739f98d72de5464c526e0851d2fb109f22d4e6dbdc7cb4445e88ca970"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7581d481bb3af741c877cca49f18c3d9f24db7639f235409cf6e102871f45c82"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "575a55a9baedee36c58bca1e229607d89952028d5fb9fd056118ab923c365de2"
    sha256 cellar: :any_skip_relocation, sonoma:        "c834aec5d5a72c3ab8cfcbba77a221b50dccd61e63683265e6ac93f3749901ab"
    sha256 cellar: :any_skip_relocation, ventura:       "1e6972dc2fb08ea5c614580d56863688b4753592a69b9bd157042ba381e948cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "573b0fe3839bbf408211f0c811bbe12ec2a88c85a6969a1fa6760febe4dac4c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da5534fb2eb8c7f91a9232553524ee70346d8b9e4d432190882720da8ba52f33"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/overtls-bin -V")

    output = shell_output(bin/"overtls-bin -r client -c #{pkgshare}/config.json 2>&1", 1)
    assert_match "Error: Io(Kind(TimedOut))", output
  end
end
