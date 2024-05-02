class PfetchRs < Formula
  desc "Pretty system information tool written in Rust"
  homepage "https://github.com/Gobidev/pfetch-rs"
  url "https://github.com/Gobidev/pfetch-rs/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "6d8ffcad261bfed71070dd5bae6c12458b33ffa4a9245ce702e3a6f7772dde8e"
  license "MIT"
  head "https://github.com/Gobidev/pfetch-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c677103dc5a98d935edc7b8c77ff3b626e38cca92287f689a1d124f3710165a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14769f38d44ef652f25d98d6564f5186728674c820fa2d2145fb847d9c280afc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7bae4e1cc7ef79ec6a806a299fd9806c5cf37fd68c60599b84c727c999610fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "0891d65cad1fd04811d5cf6116514251ad4ccc4326d78b252a5c669207a0ddd5"
    sha256 cellar: :any_skip_relocation, ventura:        "792b13a93fddde155d0aaa9faf58aa9cbf5cf09501f264f700a44a254126c33b"
    sha256 cellar: :any_skip_relocation, monterey:       "37bd3c2bce4c9ed2b5c96da0c866f880a3457055a7a5f064b8ee0464a37df925"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5743df51eb801542f0ba8ac03f7efa55d13e49c24acd2334361a486c2456e1a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "uptime", shell_output("#{bin}/pfetch")
  end
end
