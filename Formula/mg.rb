class Mg < Formula
  desc "Small Emacs-like editor"
  homepage "https://devio.us/~bcallah/mg/"
  url "https://devio.us/~bcallah/mg/mg-20160815.tar.gz"
  sha256 "d4cf4cc5e811f13bfcebd0240d074344d0a6e8c27e5a5d9be9c5e53f328a416a"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "5ed12a2bdce7b76ff2f336a0dcc1ec1be95cf8194cd253600d6edde4de51ac36" => :el_capitan
    sha256 "1feeace7595726f96687dc2ee0bf2836ac9aaba982d39306f32703047340827d" => :yosemite
    sha256 "f199621c41a7f6af908017610eac17f5d81da652ceeab148560afb96c8ba9ccc" => :mavericks
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
