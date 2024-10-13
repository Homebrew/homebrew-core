class Byacc < Formula
  desc "(Arguably) the best yacc variant"
  homepage "https://invisible-island.net/byacc/"
  url "https://invisible-mirror.net/archives/byacc/byacc-20240109.tgz"
  sha256 "f2897779017189f1a94757705ef6f6e15dc9208ef079eea7f28abec577e08446"
  license :public_domain

  livecheck do
    url "https://invisible-mirror.net/archives/byacc/"
    regex(/href=.*?byacc[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "82d767161054f28d06cdd9dba0ee76911c60197f00861266da1a04845e17e1cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d9689a35e53bfb11647dfea27c9943f6356adec3aa435082b7c5b9160a62d3bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad323ecf849316b79f9647eaa7f8a07c93041c72fdb6b739c0ea21de9797194e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f692de26b32ba58379da96eea29f0f170d4fd86da51d975d595d7c3b0098f107"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e96b9b1fa077cc47b35ab745ac97e1b34b210a29bc44c0b041832dc9151f978"
    sha256 cellar: :any_skip_relocation, ventura:        "ab3d92f531d410ea7deed110794c1e29ee188c87a1e6b7953587d18e54a745e0"
    sha256 cellar: :any_skip_relocation, monterey:       "a2cc93a64020cbb540ab14080ec7bd5f0c07a56a4b93b1109953ad1916ea0c5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6ba6891c56da94c6f57029a29d01c4a0b7df2096683a571e1c19efacd4495a3"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--program-prefix=b", "--prefix=#{prefix}", "--man=#{man}"
    system "make", "install"
  end

  test do
    system bin/"byacc", "-V"
  end
end
