class Logcheck < Formula
  desc "Mail anomalies in the system logfiles to the administrator"
  homepage "https://packages.debian.org/sid/logcheck"
  url "https://deb.debian.org/debian/pool/main/l/logcheck/logcheck_1.3.21.tar.xz"
  sha256 "54e855adcf364f685753435d3d4f333d35d7014a9ad9acf4765bbaf7554bba36"
  license "GPL-2.0-only"

  livecheck do
    url "https://packages.debian.org/unstable/logcheck"
    regex(/href=.*?logcheck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4af2e10c4914663440c40f8149b0fee3a03598ac9b24577750f7a95115db72f1"
    sha256 cellar: :any_skip_relocation, big_sur:       "8907bcff70936e3418f4194860e7874990a71958028f11d42caf720e856d15f8"
    sha256 cellar: :any_skip_relocation, catalina:      "d181f0b17c7518ae41e0b6e45f2eb533273f6868f19ec0412d302b3b70fbdd52"
    sha256 cellar: :any_skip_relocation, mojave:        "6ed00ab1ce56bd1cee25785f373f20362a8e4bf6e998026eac635086e4cccb71"
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
