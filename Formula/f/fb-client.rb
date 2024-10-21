class FbClient < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Shell-script client for https://paste.xinu.at"
  homepage "https://paste.xinu.at"
  url "https://paste.xinu.at/data/client/fb-2.3.0.tar.gz"
  sha256 "1164eca06eeacb4210d462c4baf1c4004272a6197d873d61166e7793539d1983"
  license "GPL-3.0-only"
  revision 2

  livecheck do
    url :homepage
    regex(%r{Latest release:.*?href=.*?/fb[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "3b570c1a3f374cc935d1410478bedfd3747a9aa45701db997f56e84b6ad1fd12"
    sha256 cellar: :any,                 arm64_sonoma:  "034252749348b8726609632cbe00f8fc8a6d5302d90e0715e3ef7f38cce17075"
    sha256 cellar: :any,                 arm64_ventura: "5efc3735519f642d026d2a89bd65b849336c6e0053b6dd1793c8d398992ab1c6"
    sha256 cellar: :any,                 sonoma:        "6153d56a2e1099121819856c504f6171705431b8c7e56e1daf2a5250929a5c72"
    sha256 cellar: :any,                 ventura:       "0ab8a9ec411a5979fc7b9927264b90d4bf7362af250ac0dfac180da339b10ad3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9df6820eecd2924ec0458ba37fd14e21844091f98554dc47c60973832836b57b"
  end

  depends_on "curl"
  depends_on "openssl@3"
  depends_on "python@3.13"

  conflicts_with "spotbugs", because: "both install a `fb` binary"

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/c9/5a/e68b8abbc1102113b7839e708ba04ef4c4b8b8a6da392832bb166d09ea72/pycurl-7.45.3.tar.gz"
    sha256 "8c2471af9079ad798e1645ec0b0d3d4223db687379d17dd36a70637449f81d6b"

    # Remove -flat_namespace
    # PR ref: https://github.com/pycurl/pycurl/pull/855
    on_sequoia :or_newer do
      patch do
        url "https://github.com/pycurl/pycurl/commit/7deb85e24981e23258ea411dcc79ca9b527a297d.patch?full_index=1"
        sha256 "a49fa9143287398856274f019a04cf07b0c345560e1320526415e9280ce2efbc"
      end
    end
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  def install
    venv = virtualenv_create(libexec, "python3.13")
    venv.pip_install resources

    rw_info = python_shebang_rewrite_info(libexec/"bin/python")
    rewrite_shebang rw_info, "fb"

    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"fb", "-h"
  end
end
