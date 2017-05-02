class Logcheck < Formula
  desc "Mail anomalies in the system logfiles to the administrator"
  homepage "https://logcheck.alioth.debian.org/"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/l/logcheck/logcheck_1.3.18.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/l/logcheck/logcheck_1.3.18.tar.xz"
  sha256 "077b9149ccd2b747b52785afa89da844f3d072c017c9e719925dec6acb9a9af4"

  bottle do
    cellar :any_skip_relocation
    rebuild 3
    sha256 "7fe24461210fc2d5f4809e08566e85e010a2715b9b7a6426f686327f40f25cdf" => :sierra
    sha256 "aab0ab066fe378c88c74b9783a90fb0a4896dd3a6258d00b08cd1d0d2987b108" => :el_capitan
    sha256 "c75e01fb14bdd0adfc04e110a3c8a65d036b9bd71ac03a6ac58d69006a892fe9" => :yosemite
    sha256 "25f2dfec7bb30fded535bdb354767a2680108dcd93d0627f8384a115c008cf89" => :mavericks
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
