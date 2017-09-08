class Bonniexx < Formula
  desc "Benchmark suite for file systems and hard drives"
  homepage "https://www.coker.com.au/bonnie++/"
  url "https://www.coker.com.au/bonnie++/bonnie++-1.97.3.tgz"
  mirror "https://fossies.org/linux/privat/bonnie++-1.97.3.tgz"
  sha256 "e27b386ae0dc054fa7b530aab6bdead7aea6337a864d1f982bc9ebacb320746e"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "a907767a514063b80faccd7760b299aac95ee79fc736c210f3215fbfcb106a4c" => :sierra
    sha256 "d3a7233d84654028c12bd9b177ffa09a83d6cf4a9bbbe76656332472a7cd3e7d" => :el_capitan
    sha256 "b4aa055bc2828f007a6337319ca18499b8cd6520cc405907f21df3b264a448c7" => :yosemite
  end

  # Remove the #ifdef _LARGEFILE64_SOURCE macros which not only prohibits the
  # intended functionality of splitting into 2 GB files for such filesystems but
  # also incorrectly tests for it in the first place. The ideal fix would be to
  # replace the AC_TRY_RUN() in configure.in if the fail code actually worked.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/57a21ef/bonnie%2B%2B/remove-large-file-support-macros.diff"
    sha256 "4d38a57f8a3d99405d945bb27ffe81e0ab542b520f2de6fad021a6ad3ff8a3b6"
  end

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
