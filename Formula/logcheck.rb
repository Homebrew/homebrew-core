class Logcheck < Formula
  desc "Mail anomalies in the system logfiles to the administrator"
  homepage "https://packages.debian.org/sid/logcheck"
  url "https://deb.debian.org/debian/pool/main/l/logcheck/logcheck_1.3.20.tar.xz"
  sha256 "9fb6d02b933470d0b1d1efb54ea186e0d0d27336f9d146be592f65ce60dfb3e6"

  bottle do
    cellar :any_skip_relocation
    sha256 "9e354b3fe568c0751443a702251949b5227a5ce09e3bbae4c28664aa1d7f0631" => :catalina
    sha256 "111520f51e26088aa012bd42dc772e0a00e41decec22011a2bcf71c2ee3e20cc" => :mojave
    sha256 "111520f51e26088aa012bd42dc772e0a00e41decec22011a2bcf71c2ee3e20cc" => :high_sierra
    sha256 "12caeda115373b2b964509c07c2101926ab2e67154176078bf72353f3aeab7a3" => :sierra
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
