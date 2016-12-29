class Mg < Formula
  desc "Small Emacs-like editor"
  homepage "https://devio.us/~bcallah/mg/"
  url "https://devio.us/~bcallah/mg/mg-20161016.tar.gz"
  sha256 "bcb4be59aaa30ae8dd0e9aed3c0a5ff8bf2dae6e6768396d37c11aaaab29d370"

  bottle do
    cellar :any_skip_relocation
    sha256 "4aed2dfd90c3bab684d69183bfa315fc2ece5b3b8a15c4dd6ea9f4905fd44c4f" => :sierra
    sha256 "20bba78b053638d1e05c80a678f4107aa928760c0caab7b3b8a112b6ec624afa" => :el_capitan
    sha256 "b75b2d2ce24746207c5d0253745a992ae6e6a83f190a32ba5fd4aedd08028bb5" => :yosemite
  end

  depends_on :macos => :yosemite # older versions don't support fstatat(2)

  conflicts_with "mg3a", :because => "both install `mg` binaries"

  def install
    system "make", "install", "PREFIX=#{prefix}", "MANDIR=#{man}"
  end

  test do
    (testpath/"command.sh").write <<-EOS.undent
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
