class ArpScanRs < Formula
  desc "ARP scan tool written in Rust for fast local network scans"
  homepage "https://github.com/kongbytes/arp-scan-rs"
  url "https://github.com/kongbytes/arp-scan-rs/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "9cd8ae882d47aef59f79ceedc797a9697b0f1b81916488a43a84b0a807b482fa"
  license "AGPL-3.0-or-later"
  head "https://github.com/kongbytes/arp-scan-rs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "402e25b075591a2b324adfb852c1a457d445ea9821c6be9f6056f07fe38308ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcd5eb8d1a5225c52e76fdeabc79fdff7d97ecf88ae25671a7c647cfb3867c31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76c6baf3ec726dcd760b513fcb2be26f5edbd68592e99e444a1b9ffeaee8878e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4121091ba5ad198c3498f015af7ca9b6ede928b8e43b525529b9e0554d3fa07f"
    sha256 cellar: :any_skip_relocation, sonoma:        "95a48cfa4db0dd5ae427484d1785ec5cc6bc1d741c3930ded3423dcaf8b7afbc"
    sha256 cellar: :any_skip_relocation, ventura:       "435b583d3a01fa0504ac92950115c41a72d23c96001f170fd9e3316465758b5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22825e69ba7b9bef557bfdf6145a5c5b5a53a655c294028c5e359f039d253253"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de71563f7071cdd6b37930ca4f20f2e9c3746f3befa53c9353822dc0dc838c70"
  end

  depends_on "rust" => :build

  conflicts_with "arp-scan", because: "both install `arp-scan` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/arp-scan --version")
    assert_match "Default network interface", shell_output("#{bin}/arp-scan -l")
  end
end
