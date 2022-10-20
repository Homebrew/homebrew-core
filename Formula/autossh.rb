class Autossh < Formula
  desc "Automatically restart SSH sessions and tunnels"
  homepage "https://www.harding.motd.ca/autossh/"
  url "https://www.harding.motd.ca/autossh/autossh-1.4g.tgz"
  mirror "https://deb.debian.org/debian/pool/main/a/autossh/autossh_1.4g.orig.tar.gz"
  sha256 "5fc3cee3361ca1615af862364c480593171d0c54ec156de79fc421e31ae21277"

  livecheck do
    url :homepage
    regex(/href=.*?autossh[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d14799b6ca48526b2cf94de0ec192da8689fcec70dff538a554cce942c9a1520"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c96653d1f3146ed3d7a2fea7127bae950f5b0766885385983e1ac086eda5dd43"
    sha256 cellar: :any_skip_relocation, monterey:       "a99fb17beece2065e5e184f5dcf707011c2470a05644be7ae495bcd10c99410c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9a7e07af1ad3391c1bd209b32dd92370bc93afb47c0a65499be89990ef471fe"
    sha256 cellar: :any_skip_relocation, catalina:       "48e2beb06564ae4715df08b98577b10d01a25750e720b188b863ea8f195278ef"
    sha256 cellar: :any_skip_relocation, mojave:         "2674ee43690b5d99490a0979359fdefa52033650b935547a6353de726f916275"
    sha256 cellar: :any_skip_relocation, high_sierra:    "f88fcb32499fff8aa2899c85fc39dc6678ebed2849791a4312d427d9073b6b98"
    sha256 cellar: :any_skip_relocation, sierra:         "78d258f52bc14a2539da8c6d3ce69db5c062bb70e95130d9f22113720f853c67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "382150d095c1ca848c38eabfd93635ecf9868291ec5cb85bdae6a16a53dc7ea9"
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
