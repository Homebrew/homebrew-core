class Dnsdist < Formula
  include Language::Python::Virtualenv

  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-2.1.0.tar.xz"
  sha256 "8714b7ca065b2d7ae5da980bc81a94d2baaa725a9b3c2c23b3a0fadb7c6a8335"
  license "GPL-2.0-only" # with OpenSSL Exception (non-SPDX)

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "a2d9be871d32690d33509031253e3c15bbe0458d43b90696378f9d2b01af5376"
    sha256 arm64_sequoia: "05327ad4c2f2a5339b15771a43169ecfee2874993707cb3493c08ae28195f892"
    sha256 arm64_sonoma:  "b4b2da3500baf8acb9891c8755f7187f7b92eea4113defd37b7f01149dcc0818"
    sha256 sonoma:        "b56236c572330b7aab32cf900f5d0b5135347ffac50233e13a5bb5bc7e0130a6"
    sha256 arm64_linux:   "b59dfe49527a7b53f08b61d238d7af80c22d4fa9f0238a3724b3024b72316362"
    sha256 x86_64_linux:  "b3a6fa9b257a0fd94ea8a7d7679a44865c47abd0f4215763ec35759467ecffad"
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
    venv = virtualenv_create(buildpath/"bootstrap", "python3.14")
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
                          "--sysconfdir=#{pkgetc}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"dnsdist.conf").write "setLocal('127.0.0.1')"
    output = shell_output("#{bin}/dnsdist -C dnsdist.conf --check-config 2>&1")
    assert_match "Configuration OK", output
  end
end
