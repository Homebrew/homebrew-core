class Dnsdist < Formula
  include Language::Python::Virtualenv

  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-2.0.6.tar.xz"
  sha256 "b861d74abb0da59cff4e58760266198196eee7c10f2bfe86a3f5ccbd6768626b"
  license "GPL-2.0-only" # with OpenSSL Exception (non-SPDX)

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "c474a338328ce3a3e6dfa1e3368e9f8847b28be3652b67330569f9662c6907a9"
    sha256 arm64_sequoia: "df6310d7b0527638b952491ecbd47c71dc491729f1207e99f08e5a0659226130"
    sha256 arm64_sonoma:  "c1f02099b3b93a832d9ac15f9952051dba5f744724e52f975c4700ceaa510b35"
    sha256 sonoma:        "af027aaf15ff9d506080e2e794c1efb7d5d99e78781e154277790bc1fe9fd5c3"
    sha256 arm64_linux:   "4e9fb0c0ebc70f49ca5b45eb6d9a24004ef81a0d748eb042797b2a9053facd72"
    sha256 x86_64_linux:  "26a998e7a39cbad60707d951a36ad2360cf1cd127c1252702f3a3d3c63690906"
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
    assert_equal "Configuration 'dnsdist.conf' OK!", output.chomp
  end
end
