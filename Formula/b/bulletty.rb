class Bulletty < Formula
  desc "Pretty feed reader (ATOM/RSS) that stores articles in Markdown files"
  homepage "https://bulletty.croci.dev/"
  url "https://github.com/CrociDB/bulletty/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "93b1da89b46877ee34b2f1688bcf052411c67c74d0e09299adee38ecd86309e5"
  license "MIT"
  head "https://github.com/CrociDB/bulletty.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "343c40afa97cf836303f63c6961e5ca930b84d1960f59ce61c16bf1c2f646e12"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0489b8d9ec6050527d11bd57996dee30fbff8973c4e2553c8c91fb3e5b979187"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a270ac782a1b7517824fc0775f3da86cceedc7c3d17aa5ce047ab2a0308ea5f1"
    sha256 cellar: :any,                 arm64_linux:       "be398e9954d14e8cc4abb8d032db94736f19c419b800e632bb76939f3a787bc5"
    sha256 cellar: :any,                 x86_64_linux:      "457d123f39b4ac2c89a230a073e0dc2afd9581a5d6e086b8afe0ab9a668e77cd"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bulletty --version")
    assert_match "Feeds Registered", shell_output("#{bin}/bulletty list")
  end
end
