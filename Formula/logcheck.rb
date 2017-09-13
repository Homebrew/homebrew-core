class Logcheck < Formula
  desc "Mail anomalies in the system logfiles to the administrator"
  homepage "https://logcheck.alioth.debian.org/"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/l/logcheck/logcheck_1.3.18.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/l/logcheck/logcheck_1.3.18.tar.xz"
  sha256 "077b9149ccd2b747b52785afa89da844f3d072c017c9e719925dec6acb9a9af4"

  bottle do
    cellar :any_skip_relocation
    sha256 "ce71670cdeba739650cd716867e12cda182a948189a68ca565d318299f847a61" => :sierra
    sha256 "94fde1124326dc8ed8428878b84db52b22b4ce1c19949ee0dd170402164cbadd" => :el_capitan
    sha256 "94fde1124326dc8ed8428878b84db52b22b4ce1c19949ee0dd170402164cbadd" => :yosemite
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
