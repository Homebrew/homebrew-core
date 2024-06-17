class PfetchRs < Formula
  desc "Pretty system information tool written in Rust"
  homepage "https://github.com/Gobidev/pfetch-rs"
  url "https://github.com/Gobidev/pfetch-rs/archive/refs/tags/v2.9.2.tar.gz"
  sha256 "fc77a436c3d2a3904e50c0a9390aeabd39326133f6e184b5b1eaa2a638c642f8"
  license "MIT"
  head "https://github.com/Gobidev/pfetch-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ffa8ff1594c26babf587a8a448a6ae3601b72d7f3a909352549298d6402c47be"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5aad36a586deb096340a53c19b0033597001ea2069a8ebc67e46a404aaf2031c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e542179ee60799362007a3bc3229684f3402294c49db30ea46626ca8b842422"
    sha256 cellar: :any_skip_relocation, sonoma:         "a4a48f2f24e97425062297343947f75f3550b43a6cb753a5721ee3deb17df14f"
    sha256 cellar: :any_skip_relocation, ventura:        "e500f010c527fde858d18fa2706b6b65d2b223f8316dcd9ca1710d1a6944dc89"
    sha256 cellar: :any_skip_relocation, monterey:       "baa98439198eb422be002ac14afed0ab08cfdae64fc49307960252d6f1210156"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45e515f64e9668a4190608ce73d2b7fec36dbf64ecf69bcc02a698c64cdf8a7c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "uptime", shell_output("#{bin}/pfetch")
  end
end
