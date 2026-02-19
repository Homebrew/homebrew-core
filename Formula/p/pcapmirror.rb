class Pcapmirror < Formula
  desc "Tool for capturing network traffic on remote host using TZSP or ERSPAN"
  homepage "https://git.freestone.net/cramer/pcapmirror"
  url "https://git.freestone.net/cramer/pcapmirror/-/archive/0.6.1/pcapmirror-0.6.1.tar.gz"
  sha256 "d5efbb9b8526b8b319f3040f6a7c9532c0ca9d862b1d21100e7fc8665d0bb638"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16bc789f10ee4295caa87094965aa79ea94bd622ca90323aaa2edef273cb95a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe8180edeb967556b05996bf7dca34a88c504254df62ff0cc0e065d9fab931b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3aa36ca74213168308a6ed326403c07296e0cf0857526af047c1056e187eb543"
    sha256 cellar: :any_skip_relocation, sonoma:        "edc10b49130adeb581e4ff3b5c962b1374de3ccf416984fcca13cc5a2e2045ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46ea8fd30ca7740102c048d9f9f5aecc3a80cc1a4938b6f2eb4f05471703fad5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b38420c8c3bfad8a5334c2d82d7ca1adf1897eb515e8a0710115d4c8dc3bbbaa"
  end

  depends_on "make" => :build
  uses_from_macos "libpcap"

  on_linux do
     depends_on "libpcap"
  end

  def install
     bin.mkpath
     man8.mkpath
     system "make", "install", "BINDIR=#{bin}", "MANDIR=#{man}"
  end

  test do
     assert_match "Available network interfaces:", shell_output("#{bin}/pcapmirror -l")
  end
end
