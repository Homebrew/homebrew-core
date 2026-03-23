class PfetchRs < Formula
  desc "Pretty system information tool written in Rust"
  homepage "https://github.com/Gobidev/pfetch-rs"
  url "https://github.com/Gobidev/pfetch-rs/archive/refs/tags/v2.11.1.tar.gz"
  sha256 "478b637b75a496f0adaba9c3ef0d3f99d9af6ed11eec156c90d0c8cb4b7df209"
  license "MIT"
  head "https://github.com/Gobidev/pfetch-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b8869eb94d2f2eacf898bd934be26ccacad111b41828cd4910d01975329ca59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "938aaf3f057099bc1e3a498576f712982f218b1c125b0830b72fe712d5a3ce48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6626ec120c0173e26448fcc06cce8a285d2b07414ae024e0dff4942b30451afb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d037daa279b52f6199cbb6a9fcefa156b4d95f110de49c52d4cba009d261bfe3"
    sha256 cellar: :any_skip_relocation, sonoma:        "270e81997e47b2d7307ce0e8ee95a4f553e0277019ac1a361abdd9ab1336833a"
    sha256 cellar: :any_skip_relocation, ventura:       "bc0edf9427e2be7eeff636925b06c2170b9565e7bcdede47e0b1454932c67462"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f575a553467d25369d3416cb58de53e812b91ffc3f7c3c851dff3190e6ee297"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "502209e4ed7e51463bee5bfb8f746c6913a9f01cef928da2a4f7df9aed7797fa"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "uptime", shell_output("#{bin}/pfetch")
  end
end
