class Kanif < Formula
  desc "Cluster management and administration tool"
  homepage "https://packages.debian.org/stable/net/kanif"
  url "https://deb.debian.org/debian/pool/main/k/kanif/kanif_1.2.2.orig.tar.gz"
  sha256 "3f0c549428dfe88457c1db293cfac2a22b203f872904c3abf372651ac12e5879"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/k/kanif/"
    regex(/href=.*?kanif[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "f8e0c833384c4479f288c31b55223157190f271ca6489bbcc47cfb8c9c2042e8"
  end

  depends_on "taktuk"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "taktuk -s -c 'ssh' -l brew",
      shell_output("#{bin}/kash -q -l brew -r ssh")
  end
end
