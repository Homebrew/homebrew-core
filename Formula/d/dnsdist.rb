class Dnsdist < Formula
  include Language::Python::Virtualenv

  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-2.0.4.tar.xz"
  sha256 "2f4194be2f63a1778d47647738b55ade642e09c57fb4469bcb7111c2eefda89b"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "f4d36e27a24046bf7deff9f48905c71da00a3b9ecb03b33e8139e117e0c88a62"
    sha256 arm64_sequoia: "e629d7a11d2c5f494df0ff18ee458cbfa3bcc9c61314907ec84696369caa40ec"
    sha256 arm64_sonoma:  "dbbcd3d3df59bb6a524446bf44210d2563526f9ceee92e8dbcb70eb50d862232"
    sha256 sonoma:        "e8aedf210313427b9ca4d685a3ccdee8d58b1e1de7c51c41f3e34355366aa8a1"
    sha256 arm64_linux:   "896433e2b37f95333dbf7d81fd20b23d2c36ddb075904e9cdb938fe7b9c5b784"
    sha256 x86_64_linux:  "3531becff3e0791c2d4b61bbc026f3f54268a852074b9092f427efed7230a3ab"
  end

  depends_on "boost" => :build
  depends_on "libyaml" => :build # for PyYaml
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "fstrm"
  depends_on "libnghttp2"
  depends_on "libsodium"
  depends_on "luajit"
  depends_on "openssl@3"
  depends_on "re2"
  depends_on "tinycdb"

  uses_from_macos "libedit"

  pypi_packages package_name:   "",
                extra_packages: "pyyaml"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    # Fix to error: use of undeclared identifier 'vinfolog'
    inreplace "dnsdist-protobuf.cc", '#include "dnsdist-protobuf.hh"', "\\0\n#include \"dolog.hh\""

    venv = virtualenv_create(buildpath/"bootstrap", "python3")
    venv.pip_install resources
    ENV.prepend_path "PATH", venv.root/"bin"

    # Avoid over-linkage to `abseil`.
    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac?

    system "./configure", "--disable-silent-rules",
                          "--without-net-snmp",
                          "--enable-dns-over-tls",
                          "--enable-dns-over-https",
                          "--enable-dnscrypt",
                          "--with-re2",
                          "--sysconfdir=#{etc}/dnsdist",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"dnsdist.conf").write "setLocal('127.0.0.1')"
    output = shell_output("#{bin}/dnsdist -C dnsdist.conf --check-config 2>&1")
    assert_equal "Configuration 'dnsdist.conf' OK!", output.chomp
  end
end
