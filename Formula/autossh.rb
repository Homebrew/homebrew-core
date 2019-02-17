class Autossh < Formula
  desc "Automatically restart SSH sessions and tunnels"
  homepage "https://www.harding.motd.ca/autossh/"
  url "https://www.harding.motd.ca/autossh/autossh-1.4f.tgz"
  mirror "https://deb.debian.org/debian/pool/main/a/autossh/autossh_1.4f.orig.tar.gz"
  sha256 "0172e5e1bea40c642e0ef025334be3aadd4ff3b4d62c0b177ed88a8384e2f8f2"

  bottle do
    cellar :any_skip_relocation
    sha256 "80ea151fa465a49fc65ff6de0e5ed75300c42b37179012c87eea4aebfaa28443" => :mojave
    sha256 "d9bb50e0a96fe80d177541ed317032e4f0d1d66af70aed5fcb804299384bdd87" => :high_sierra
    sha256 "75d84cea4022291022508dd13d231c6beb599e95256759856051e1cdcc385541" => :sierra
    sha256 "fea4dce29ebf3308cddd9f36f209a401933998821b3b8fa8845130d340d487e2" => :el_capitan
  end

  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
    bin.install "rscreen"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/autossh -V")
  end
end


__END__
diff --git a/rscreen b/rscreen
index f0bbced..ce232c3 100755
--- a/rscreen
+++ b/rscreen
@@ -23,4 +23,4 @@ fi
 #AUTOSSH_PATH=/usr/local/bin/ssh
 export AUTOSSH_POLL AUTOSSH_LOGFILE AUTOSSH_DEBUG AUTOSSH_PATH AUTOSSH_GATETIME AUTOSSH_PORT
 
-autossh -M 20004 -t $1 "screen -e^Zz -D -R"
+autossh -M 20004 -t $1 "screen -D -R"
