class Dnsdist < Formula
  include Language::Python::Virtualenv

  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-2.1.1.tar.xz"
  sha256 "bdb6cdbf56c4c2448b112f74c94c15b0b2764703faeebe7dc5ad56b4b5a9a576"
  license "GPL-2.0-only" # with OpenSSL Exception (non-SPDX)

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "8d1119f20446fa1e19013a2cd762d4ffd8f60c91c8915553115ea8c49d488d78"
    sha256 arm64_sequoia: "81a28beeccae5007be3eb2e6c727b356c779b6c2b9386df2ab08f0c92c549e56"
    sha256 arm64_sonoma:  "118ecfb11c797747e80d8fee1a6cd31361a12ed676a9e431ceaf97ce4947458b"
    sha256 sonoma:        "9cbd391e1ce1fca71f0611ec65ccc65defa968e99b9251c5073bc4c46d7bb482"
    sha256 arm64_linux:   "57c8c61be292a82deceeb74c06ab12f6bfb90392a94c90f6b448961e5e54dbf2"
    sha256 x86_64_linux:  "b89c9fd87dbd14864f146cd00dae2b40ee214eba695933c90915835d4fc01bbd"
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
