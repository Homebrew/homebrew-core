class PfetchRs < Formula
  desc "Pretty system information tool written in Rust"
  homepage "https://github.com/Gobidev/pfetch-rs"
  url "https://github.com/Gobidev/pfetch-rs/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "2f5dea37e327267aa48d69c7ed267da8fa24d4fcd69d8caed9baee709811c311"
  license "MIT"
  head "https://github.com/Gobidev/pfetch-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f86f192ff534cd8375bbd7ccaf99d2058a02b14df9ad6ba73420043f5269daa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e62eb93926d4abde9a0e199f83a56907e79538e547b06fb2f8b237d115c72f34"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f661e256c9d560068997d71e7d8002135b931ddb1ce547aa18a82416078fa9e"
    sha256 cellar: :any_skip_relocation, ventura:        "50dd7af5937a4893fbaa534f50eb356ab0e145b1e88dc38cd2f336578548fb5c"
    sha256 cellar: :any_skip_relocation, monterey:       "3b323abe3ffc8a2eba598d043ce055fc9eea470a55faa1a288f6e6df1e2bfa4d"
    sha256 cellar: :any_skip_relocation, big_sur:        "60bfc29fea344dd0970c4bfb22f1a48b83c29498e7248b2888fb2a2845276c3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27af92224571e7d6458bf7a13212ab70230bc768039b4a49e32dacf362ef3aa9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "uptime", shell_output("#{bin}/pfetch")
  end
end
