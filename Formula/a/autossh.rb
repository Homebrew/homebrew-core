class Autossh < Formula
  desc "Automatically restart SSH sessions and tunnels"
  homepage "https://www.harding.motd.ca/autossh/"
  url "https://www.harding.motd.ca/autossh/autossh-1.4g.tgz"
  mirror "https://deb.debian.org/debian/pool/main/a/autossh/autossh_1.4g.orig.tar.gz"
  sha256 "5fc3cee3361ca1615af862364c480593171d0c54ec156de79fc421e31ae21277"
  license "BSD-1-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?autossh[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "33e051fb258b827ab535ba5909806f87dc63a82f3d3fe9117be1f3c0aa7f4045"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "66600f6f9ea804ec6342ea35c6bd26c068802f31dce3eb09ec161eb67fde8415"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d6adeb0a9a13c4e256e4f585524fcb8c7ec49878d876f3d66ecbc9ec62474d16"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c292dd6b6f1393dbccbdc296b881f30844787c909605577ee7367b0b77c0a793"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d14799b6ca48526b2cf94de0ec192da8689fcec70dff538a554cce942c9a1520"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c96653d1f3146ed3d7a2fea7127bae950f5b0766885385983e1ac086eda5dd43"
    sha256 cellar: :any_skip_relocation, sonoma:         "15ac495d0360f64bbd48a11967af2aab8f12b17b7250579653fd1e085e33feb7"
    sha256 cellar: :any_skip_relocation, ventura:        "d1712ac93597119c8ba5cf1f945243b52ef382241e868920753e0d18b8a3944d"
    sha256 cellar: :any_skip_relocation, monterey:       "a99fb17beece2065e5e184f5dcf707011c2470a05644be7ae495bcd10c99410c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9a7e07af1ad3391c1bd209b32dd92370bc93afb47c0a65499be89990ef471fe"
    sha256 cellar: :any_skip_relocation, catalina:       "48e2beb06564ae4715df08b98577b10d01a25750e720b188b863ea8f195278ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d60fa3c4409563c4ee150db9420c1690afd67a5ddc4b275164a388543b2d6e54"
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
