class Mg < Formula
  desc "Small Emacs-like editor"
  homepage "https://devio.us/~bcallah/mg/"
  url "https://devio.us/~bcallah/mg/mg-20180421.tar.gz"
  sha256 "11215613a360cf72ff16c2b241ea4e71b4b80b2be32c62a770c1969599e663b2"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd9c1d6d792d7c9ba725c46e8247053c6fcaa5af5f6e5807d91a7219bf72cff0" => :high_sierra
    sha256 "279095340e89cd20a28008b3db888d6dbe7fa0d0d023f95ee7c71ad07f22aef3" => :sierra
    sha256 "8e2193d88c0ae77696b0612ce830a7fbdf73aa633d0680ec8c84a9d71a30c529" => :el_capitan
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
