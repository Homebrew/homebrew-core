class Ephemeralpg < Formula
  desc "Run tests on an isolated, temporary Postgres database"
  homepage "https://eradman.com/ephemeralpg/"
  url "https://eradman.com/ephemeralpg/code/ephemeralpg-3.3.tar.gz"
  sha256 "a5542b7d2a70267c42457014a59419b1bd19ff094b6e375a6268557af807ae0a"
  license "ISC"

  livecheck do
    url "https://eradman.com/ephemeralpg/code/"
    regex(/href=.*?ephemeralpg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "de31708cf532a53e8d09b386f237fded6d3a0ad9e6785a7d1404d623cfa9520e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ecf856847b6aff6ab068bdb117c5f28bae5b4f075640a87166f4bd3025e49b9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ab31d0519112830bee42b0b3548bf56604b263fd3b0b2876125c4d58f897d92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00527173690ac6008cab51f1c07280a064e9067288609ac0adde6df9ade3e734"
    sha256 cellar: :any_skip_relocation, sonoma:         "93e5251251096b39758db89bfe15aec91e03fd9617fc4823e1ac2a716aa7d597"
    sha256 cellar: :any_skip_relocation, ventura:        "c5c4f8f2f0f913156fb7cd29e1af079689f8df230d1d98a1d676923ffc36a7e0"
    sha256 cellar: :any_skip_relocation, monterey:       "0eb22d58e070b23cc9ac05ffdf772a7686706b05be5b27bde6883f70df7f9a0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c65a1a3261c1f1633accdbeae50624751450c826f6ea113c533e2b20bbeedea"
  end

  depends_on "libpq"

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "MANPREFIX=#{man}", "install"
  end
end
