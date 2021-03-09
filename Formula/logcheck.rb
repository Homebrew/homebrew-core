class Logcheck < Formula
  desc "Mail anomalies in the system logfiles to the administrator"
  homepage "https://packages.debian.org/sid/logcheck"
  url "https://deb.debian.org/debian/pool/main/l/logcheck/logcheck_1.3.22.tar.xz"
  sha256 "7bb5de44d945b1ec6556c90ad8e9cb4e6355fc44b6c5653effe00495ec55e84e"
  license "GPL-2.0-only"

  livecheck do
    url "https://packages.debian.org/unstable/logcheck"
    regex(/href=.*?logcheck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "93c3137e2f64093bbd04d83e291b6703c438c2f54624c48b66812dbe59e3e554"
    sha256 cellar: :any_skip_relocation, big_sur:       "f2bfaccdb1a53aec3701d8f35c960b3d253395f648ff32602adcc355741b5c36"
    sha256 cellar: :any_skip_relocation, catalina:      "aa5bf95cb6fe848f0577be456ee84fd3ea2e5f5e7c00ecab57d6bbc85bf2d218"
    sha256 cellar: :any_skip_relocation, mojave:        "5d88f3e85dd26050d6e65c4e980de25e7168bf6c254ac7e141c10360c41d8c28"
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
