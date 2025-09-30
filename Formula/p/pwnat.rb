class Pwnat < Formula
  desc "Proxy server that works behind a NAT"
  homepage "https://samy.pl/pwnat/"
  url "https://github.com/samyk/pwnat/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "c784ac0ef2249ae5b314a95ff5049f16c253c1f9b3720f3f88c50fc811140b44"
  license "GPL-3.0-or-later"
  head "https://github.com/samyk/pwnat.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "3fe94650a5636132e1ea4325a88f58602079e8f0e82ac12286ef3b41912b72fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "cad8dc7797afa7c06b216dd8c22990593fcdf4c020ac76a23ec4c7de3c7413d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a483fb305ae5edf4765c7fc1e881aafaf4d6ecab13267057c6434b7eda572760"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5ddbd4df3ba08892d85b2a3dd4a09df2530b1e6c65eab0ece114d756245ef8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a54673faf81eda9764a05196c50daa8c5b078d171bbf94b9b3213c478b265a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b529e5fb4cbb41a4ecbccaaeb3f5801b52036c61d1d7d747e8001c327ae9bba7"
    sha256 cellar: :any_skip_relocation, sonoma:         "e350ed81847b94a8bb052b8c48f135ae8f984abf90586cbf37d9bd0f6c6d5798"
    sha256 cellar: :any_skip_relocation, ventura:        "1551d449a55de940254f0050a256c2a9297cec0fd7f483acb89de825b3bfd15c"
    sha256 cellar: :any_skip_relocation, monterey:       "d68b2a2bd9f47b349bd50fca156330eac3abd07ab7704da5ea4c9fb5be120605"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b2649eef333edd35081d7aa05b128cc7957fedc7037383ef986cbffe4d4f1be"
    sha256 cellar: :any_skip_relocation, catalina:       "ba13960f81cbb1e739807717b54f7232b8ae5658b112c6a943d9560f9d68114f"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3b4609ea9b0e88cbb8d62bcb69fbc1f98a5fda3aa7c688f96efc0efad2be9b6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d00f8d395764951d6f77834e4fab75bed808679e85f7fe9cd939657481da51c"
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "pwnat"
    man1.install "manpage.txt" => "pwnat.1"
  end

  test do
    assert_match "pwnat <-s | -c> <args>", shell_output("#{bin}/pwnat -h", 1)
  end
end
