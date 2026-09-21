class Dnsdist < Formula
  include Language::Python::Virtualenv

  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-2.1.2.tar.xz"
  sha256 "9fcb469d7a1b5116606f2563761343d1c595523c1fd67808835fa4edc03c24ce"
  license "GPL-2.0-only" # with OpenSSL Exception (non-SPDX)

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "861d859901bd974bf36c6961f6d2bc0e251486c02a0088d3e05caffdb64890e4"
    sha256 arm64_tahoe:       "8e7e0efd34b3cbf364ceeb2654993eb1fc92faf3b5410f6fa4398e1950dfd7c2"
    sha256 arm64_sequoia:     "47c2c15b1ab56025ba1dd96d891fc394c0ef301b98b7861bb6a74425efa17f55"
    sha256 arm64_sonoma:      "3ecc7c05cea6293d15b443f366b9caac99fda43748435d69e7fcab17415228e0"
    sha256 arm64_linux:       "deffdd8789b460e08a9d1ea6c88ea98fd70e176cf6fddafc6956eda81a96461d"
    sha256 x86_64_linux:      "422c72613c57d0e6011a213e66fb00b7a09e7bf6f9a33699fcd94eda4fa0d640"
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
