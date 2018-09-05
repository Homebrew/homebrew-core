class Mg < Formula
  desc "Small Emacs-like editor"
  # https://devio.us/~bcallah/mg/ is temporarily offline
  homepage "https://github.com/ibara/mg"
  # https://devio.us/~bcallah/mg/mg-20180421.tar.gz is temporarily offline
  url "https://dl.bintray.com/homebrew/mirror/mg-20180421.tar.gz"
  sha256 "11215613a360cf72ff16c2b241ea4e71b4b80b2be32c62a770c1969599e663b2"

  bottle do
    cellar :any_skip_relocation
    sha256 "2815679e76a4eb25d454d8f8399f61fd38def65f6bcd4ac5a6b699e4c8f2344a" => :mojave
    sha256 "6ddda40fecee0d8866684f50b248bf87172df8ccbe108306226ffc3cc2d8d74b" => :high_sierra
    sha256 "e8df146cd84a6d153066c1c5398fb0846dace0529d090dbb063624f46556fb00" => :sierra
    sha256 "f0ea843971bc8cdabbfdfbc663b7ef0d89c8b1d37b5eb303bfcebf83ff6d97a7" => :el_capitan
  end

  depends_on :macos => :yosemite # older versions don't support fstatat(2)

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"command.sh").write <<~EOS
      #!/usr/bin/expect -f
      set timeout -1
      spawn #{bin}/mg
      match_max 100000
      send -- "\u0018\u0003"
      expect eof
    EOS
    chmod 0755, testpath/"command.sh"

    system testpath/"command.sh"
  end
end
