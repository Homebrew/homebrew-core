class Crunch < Formula
  desc "Wordlist generator"
  homepage "https://sourceforge.net/projects/crunch-wordlist/"
  url "https://downloads.sourceforge.net/project/crunch-wordlist/crunch-wordlist/crunch-3.6.tgz"
  sha256 "6a8f6c3c7410cc1930e6854d1dadc6691bfef138760509b33722ff2de133fe55"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ad3bd04ba230c46df88ab4ab7a74efa3182cd65b804b65a28a327f74700641e8" => :mojave
    sha256 "c59cb398b0ed4f28e8d56c49709991f5ea61b61bad4d672f1a481730948cdeb0" => :high_sierra
    sha256 "737d46b90aaa933abe03e111ece79e3f6a0ecb372cc1903b9dba3a33208111b9" => :sierra
    sha256 "84c0c275e63cc5c27fd468587f67ae5f1ab31a3923fe2eda27b4e33477356844" => :el_capitan
    sha256 "406d94f00713b83bbf41b36453605a5f85f154f88aec9b3ae23e7646ddcc03c1" => :yosemite
    sha256 "379e5d6a2a8a9baaa9b337f3e702e25ccca6025fd8b49e2685031e67d8ce8666" => :mavericks
  end

  def install
    system "make", "CC=#{ENV.cc}", "LFS=-D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64"

    bin.install "crunch"
    man1.install "crunch.1"
    share.install Dir["*.lst"]
  end

  test do
    system "#{bin}/crunch", "-v"
  end
end
