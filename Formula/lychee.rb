class Lychee < Formula
  desc "Fast, async, resource-friendly link checker"
  homepage "https://github.com/lycheeverse/lychee"
  url "https://github.com/lycheeverse/lychee/archive/v0.12.0.tar.gz"
  sha256 "2d8a08e6d64d24f7bceacf12e4d097c599bf1fbc40a146671eae4b638cde1f47"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lycheeverse/lychee.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "06cbc5d08222309a5c4227ed02573dc03fae9d2b0cc6f3db9d111ffd2cc46ca4"
    sha256 cellar: :any,                 arm64_monterey: "c25644c2db30016b76c345dffa64ab4f9926db6e9c8430a95b26715573a7acd1"
    sha256 cellar: :any,                 arm64_big_sur:  "ad43977aff1226f4a25af9129b60a25e89f23a73c7757fc0df82dfbc246e317b"
    sha256 cellar: :any,                 ventura:        "bf149ed7369b47b4fd9bfdacecdc64efd44092f7a20bba5c81b7c9bd40e118ca"
    sha256 cellar: :any,                 monterey:       "bbe3af3af60e496b32fc43269908f3ec2bda89cf41abc731d448e130cc2e1027"
    sha256 cellar: :any,                 big_sur:        "d148a61c75ba8a73159f494d39fdb6a40881eeaaf74f3964976678254b3a571a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fae66168a68ec09485c1fab3e99cb62125ab7e5b6d2810a2bf3f8e2e9936c21"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "lychee-bin")
  end

  test do
    (testpath/"test.md").write "[This](https://example.com) is an example.\n"
    output = shell_output(bin/"lychee #{testpath}/test.md")
    assert_match "🔍 1 Total ✅ 0 OK 🚫 0 Errors 💤 1 Excluded", output
  end
end
