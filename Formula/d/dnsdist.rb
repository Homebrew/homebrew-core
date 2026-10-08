class Dnsdist < Formula
  include Language::Python::Virtualenv

  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-2.1.2.tar.xz"
  sha256 "9fcb469d7a1b5116606f2563761343d1c595523c1fd67808835fa4edc03c24ce"
  license "GPL-2.0-only" # with OpenSSL Exception (non-SPDX)
  revision 1

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "29d94f308abaac9605be874ed3836ffd37da55db51a8a47ed8da301d58875135"
    sha256 arm64_tahoe:       "ce14693985419ffad1ed1f66c912092ad48f1f99d4f2787209fb1578c1fc57c5"
    sha256 arm64_sequoia:     "1f26f4d091834e062e03beece794ee5049168d222f15d8071588b93d01735d66"
    sha256 arm64_linux:       "5893c54cfd7afb7c01f2ec2a7b0e1719cf3c90265fc4f1ad6658b54b2156ed48"
    sha256 x86_64_linux:      "64590505cff41d67f133e8e0a1c02d716429d4f486643b9f9776c91dc063b754"
  end

  depends_on "boost" => :build
  depends_on "libyaml" => :build # for PyYaml
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => :build
  depends_on "fstrm"
  depends_on "libnghttp2"
  depends_on "libsodium"
  depends_on "luajit"
  depends_on "openssl@4"
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
    venv = virtualenv_create(buildpath/"bootstrap", python3)
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
