class Mg < Formula
  desc "Small Emacs-like editor"
  homepage "https://devio.us/~bcallah/mg/"
  url "https://devio.us/~bcallah/mg/mg-20170917.tar.gz"
  sha256 "def9237a89ec6a14241abaf12714bc5fcb3b0e2f8d9d466ff7561628d35b7ff1"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd9c1d6d792d7c9ba725c46e8247053c6fcaa5af5f6e5807d91a7219bf72cff0" => :high_sierra
    sha256 "279095340e89cd20a28008b3db888d6dbe7fa0d0d023f95ee7c71ad07f22aef3" => :sierra
    sha256 "8e2193d88c0ae77696b0612ce830a7fbdf73aa633d0680ec8c84a9d71a30c529" => :el_capitan
  end

  depends_on :macos => :yosemite # older versions don't support fstatat(2)

  conflicts_with "mg3a", :because => "both install `mg` binaries"

  def install
    system "make", "install", "PREFIX=#{prefix}", "MANDIR=#{man}"
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
