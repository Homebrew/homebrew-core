class PfetchRs < Formula
  desc "Pretty system information tool written in Rust"
  homepage "https://github.com/Gobidev/pfetch-rs"
  url "https://github.com/Gobidev/pfetch-rs/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "5546d66fcd5b29526f2762c0a55b236be14573c1e9adee0425e425fd19b07411"
  license "MIT"
  head "https://github.com/Gobidev/pfetch-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1fdb1dbe1230b64af06c2e620a03cd2f53413ab288f5dd8e954561ad466f95c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d4866ff19fb0423a0ee1de124dd506f809a25eb3c982d861b2c0dd5b167cccb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66c49e16c55ece2d9e31eef29a1bc9b5343b4c4eb2c3690514c1cdb25a0926de"
    sha256 cellar: :any_skip_relocation, ventura:        "47e3f7ef56da69d6aef625a822aa177b817c8dcce4166bb715cc95bfd58df9b2"
    sha256 cellar: :any_skip_relocation, monterey:       "073c0e7443a39b656ddddec860ae4daedb49fb5fd702ea46e9ccbe7f1d66eaf7"
    sha256 cellar: :any_skip_relocation, big_sur:        "1906af7fefec5d4e35476b9a15ef06c1e8e93b06f03a7e2f9147d00f9e694226"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d69a7f85aa06f38ac3b17e129f7b0e9b19cf5710af92ecef123bca41028fd6c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "uptime", shell_output("#{bin}/pfetch")
  end
end
