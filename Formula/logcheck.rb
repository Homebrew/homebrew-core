class Logcheck < Formula
  desc "Mail anomalies in the system logfiles to the administrator"
  homepage "https://packages.debian.org/sid/logcheck"
  url "https://deb.debian.org/debian/pool/main/l/logcheck/logcheck_1.4.2.tar.xz"
  sha256 "0c651deb31dc201f1584ecea292b259932bae6e3e8cef846db3109e89a7f217e"
  license "GPL-2.0-only"

  livecheck do
    url "https://packages.debian.org/unstable/logcheck"
    regex(/href=.*?logcheck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0dd5a372a2cf9bee6870ea922f2cdb988c6f73316d7323c2b60147735467575f"
  end

  on_macos do
    depends_on "gnu-sed" => :build
  end

  def install
    # use gnu-sed on macOS
    ENV.prepend_path "PATH", Formula["gnu-sed"].libexec/"gnubin" if OS.mac?

    # Fix dependency on `dpkg-parsechangelog`
    inreplace "Makefile", "$$(dpkg-parsechangelog -S version)", version.to_s
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
