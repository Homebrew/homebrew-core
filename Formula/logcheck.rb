class Logcheck < Formula
  desc "Mail anomalies in the system logfiles to the administrator"
  homepage "https://packages.debian.org/sid/logcheck"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/l/logcheck/logcheck_1.3.19.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/l/logcheck/logcheck_1.3.19.tar.xz"
  sha256 "06294c092b2115eca3d054c57778718c91dd2e0fd1c46650b7343c2a92672ca9"

  bottle do
    cellar :any_skip_relocation
    sha256 "ea40eb4c4191e7cbf09c7cd90e92eeb3ee04f9a51874169be0bba833bb3c5c02" => :mojave
    sha256 "5afc20f769f2b9326958a81eb7349e6475d599e08f1c1ffc1f9dcd7d3f3c1218" => :high_sierra
    sha256 "5afc20f769f2b9326958a81eb7349e6475d599e08f1c1ffc1f9dcd7d3f3c1218" => :sierra
    sha256 "5afc20f769f2b9326958a81eb7349e6475d599e08f1c1ffc1f9dcd7d3f3c1218" => :el_capitan
  end

  def install
    inreplace "Makefile", "$(DESTDIR)/$(CONFDIR)", "$(CONFDIR)"
    system "make", "install", "--always-make", "DESTDIR=#{prefix}",
                   "SBINDIR=sbin", "BINDIR=bin", "CONFDIR=#{etc}/logcheck"
  end

  test do
    (testpath/"README").write "Boaty McBoatface"
    output = shell_output("#{sbin}/logtail -f #{testpath}/README")
    assert_match "Boaty McBoatface", output
  end
end
