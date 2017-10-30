class Mg < Formula
  desc "Small Emacs-like editor"
  homepage "https://devio.us/~bcallah/mg/"
  url "https://devio.us/~bcallah/mg/mg-20161016.tar.gz"
  sha256 "bcb4be59aaa30ae8dd0e9aed3c0a5ff8bf2dae6e6768396d37c11aaaab29d370"

  bottle do
    cellar :any_skip_relocation
    sha256 "c6cd9d4e0aef9f2f4b178b08e1d7edb30d7657ce762fdad4f15b736ed7aca3e0" => :high_sierra
    sha256 "231f0f356fb33dbb14a21c5605b9049d834285cd7b78a6647580eb7548e823d2" => :sierra
    sha256 "510b4da455b8018934cd19d70952fe39633af1978d9f7b0bcc41d7b714dc1dcc" => :el_capitan
    sha256 "90283bf60bd3bd0f287514fc30857903f138c5177affed345962cfa9ffbb1d07" => :yosemite
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
