class Logcheck < Formula
  desc "Mail anomalies in the system logfiles to the administrator"
  homepage "https://packages.debian.org/sid/logcheck"
  url "https://deb.debian.org/debian/pool/main/l/logcheck/logcheck_1.3.23.tar.xz"
  sha256 "a2188ba549fff4412c82074b271884ff66d25f3fdb2a41916e817ce676855b29"
  license "GPL-2.0-only"

  livecheck do
    url "https://packages.debian.org/unstable/logcheck"
    regex(/href=.*?logcheck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c158a2e122bc100e2d6cdc418f774e75608cedc5fe63dc63bef450e0b608dabd"
    sha256 cellar: :any_skip_relocation, big_sur:       "f7d2d31cdd38d9b05c4b4d75d0f547204542ad12b54af4e6af80ed7f42e3db46"
    sha256 cellar: :any_skip_relocation, catalina:      "790e11ad036bfd77384e5b1bff4427560c21f942b2909b6495dd04824511f156"
    sha256 cellar: :any_skip_relocation, mojave:        "a075ab3e36e8d5a9f8f51815357cb4640193c94bf72f8623424266c640f7d63e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73d2a94487c26620d13bf3fd8093d96e9d9420caab4f36b5e34c36b3032e6eb9"
    sha256 cellar: :any_skip_relocation, all:           "73d2a94487c26620d13bf3fd8093d96e9d9420caab4f36b5e34c36b3032e6eb9"
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
