class Logcheck < Formula
  desc "Mail anomalies in the system logfiles to the administrator"
  homepage "https://packages.debian.org/sid/logcheck"
  url "https://deb.debian.org/debian/pool/main/l/logcheck/logcheck_1.4.3.tar.xz"
  sha256 "ad83ae80bd780bdae5eefd40ad59a3e97b85ad3a4962aa7c00d98ed3bdffcdd0"
  license "GPL-2.0-only"

  livecheck do
    url "https://packages.debian.org/unstable/logcheck"
    regex(/href=.*?logcheck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ecd94f7128daaac16cb1dc0d371259d177878e6d727cb189fe93d017d175de2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ecd94f7128daaac16cb1dc0d371259d177878e6d727cb189fe93d017d175de2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ecd94f7128daaac16cb1dc0d371259d177878e6d727cb189fe93d017d175de2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ecd94f7128daaac16cb1dc0d371259d177878e6d727cb189fe93d017d175de2"
    sha256 cellar: :any_skip_relocation, sonoma:         "6ecd94f7128daaac16cb1dc0d371259d177878e6d727cb189fe93d017d175de2"
    sha256 cellar: :any_skip_relocation, ventura:        "6ecd94f7128daaac16cb1dc0d371259d177878e6d727cb189fe93d017d175de2"
    sha256 cellar: :any_skip_relocation, monterey:       "6ecd94f7128daaac16cb1dc0d371259d177878e6d727cb189fe93d017d175de2"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ecd94f7128daaac16cb1dc0d371259d177878e6d727cb189fe93d017d175de2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c228270104abb0e7f124a9e278a94e3863a8e17ca9739f83c097e38cde56377a"
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
