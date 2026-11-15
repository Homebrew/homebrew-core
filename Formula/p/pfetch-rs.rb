class PfetchRs < Formula
  desc "Pretty system information tool written in Rust"
  homepage "https://github.com/Gobidev/pfetch-rs"
  url "https://github.com/Gobidev/pfetch-rs/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "13730b58a1fe20acfe32e17056f1d48a12a1ea7209c9c28507d21ccb36144466"
  license "MIT"
  head "https://github.com/Gobidev/pfetch-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6f7ed9a83c1b12632e78360d5973017eeb327945364c136924901a83aaaa0ec7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "05698bc1f5c63f76bded25f8fef0340f247d4e7758399135c7ab438b3e749133"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d9750c531c165a78d4df1acbf7a81be1c20a55b6ea2a7192304f1ca6774aac9e"
    sha256 cellar: :any,                 arm64_linux:       "778d6b2a97b9bdc4d316468c3c479cee7e2e2e8c92cba551ecb339e4c7fc274f"
    sha256 cellar: :any,                 x86_64_linux:      "90c35e3173fa33b11b968a0bf68bb1cbf8745eca074c65d9a30ea127e3405189"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "uptime", shell_output("#{bin}/pfetch")
  end
end
