class FbClient < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Shell-script client for https://paste.xinu.at"
  homepage "https://paste.xinu.at"
  url "https://paste.xinu.at/data/client/fb-2.4.0.tar.gz"
  sha256 "a3dd5580c7ba459c18f2d2ac39614422fd9c0dccb4545dbd683c77104062af39"
  license "GPL-3.0-only"
  revision 1

  livecheck do
    url :homepage
    regex(%r{Latest release:.*?href=.*?/fb[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "73eab9597ced2af5e28f7a3580e80ad54e9aebc93177dc75c121f67c5d9acb77"
    sha256 cellar: :any, arm64_tahoe:       "aea1a956520bef76111f72cd9949a8e74678117db6d7c2469877637813f5906c"
    sha256 cellar: :any, arm64_sequoia:     "e49f0cbd68444ea836e10c1c73c7dd62187bc168ca5d3295932529e04d9e57ad"
    sha256 cellar: :any, arm64_linux:       "d1c90c2c15ce11b67b596a7a147d84d6f0514adc8ee97cb0842a834382ba753d"
    sha256 cellar: :any, x86_64_linux:      "a232b396890e9972baa893618e3863110b982ae620b193da9538deb2a792b0cd"
  end

  depends_on "curl"
  depends_on "openssl@4"
  depends_on "python@3.15"

  conflicts_with "spotbugs", because: "both install a `fb` binary"

  pypi_packages package_name:   "",
                extra_packages: ["pycurl", "pyxdg"]

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/fe/62/5851dbbaba9b8ba69019ee74213f1c31b0b2b7ba643ad48e9407638b0dea/pycurl-7.48.0.tar.gz"
    sha256 "b70961a76c412cd34f9cc2c9558e63f89fb37045c59eee396c585b52973be280"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  def install
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources

    rw_info = python_shebang_rewrite_info(libexec/"bin/python")
    rewrite_shebang rw_info, "fb"

    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"fb", "-h"
  end
end
