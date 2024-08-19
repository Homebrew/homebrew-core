class FbClient < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Shell-script client for https://paste.xinu.at"
  homepage "https://paste.xinu.at"
  url "https://paste.xinu.at/data/client/fb-2.3.0.tar.gz"
  sha256 "1164eca06eeacb4210d462c4baf1c4004272a6197d873d61166e7793539d1983"
  license "GPL-3.0-only"
  revision 2
  head "https://git.server-speed.net/users/flo/fb", using: :git, branch: "master"

  livecheck do
    url :homepage
    regex(%r{Latest release:.*?href=.*?/fb[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7ca84db50325eb47477dfcaa32aa9ded3d935e2de1d36e95049f9f76936a1f3c"
    sha256 cellar: :any,                 arm64_ventura:  "afe0f6ffe32e0e5bc872fb7c6038fc4087f8130fdbb67b9ace184f0e55eb42a9"
    sha256 cellar: :any,                 arm64_monterey: "866f9e06cb09122309446292c006dc945c6fe38a0be8083de7a0f50bbe642194"
    sha256 cellar: :any,                 sonoma:         "7d196e29d73b69e9a391d8372613238f5e44cd846ed9fc56dd57c0cfb29bd2f5"
    sha256 cellar: :any,                 ventura:        "6b11d92dfb320d58be7ce9583b3146182b729837906f226368c82638144a5a6c"
    sha256 cellar: :any,                 monterey:       "71e82fb32bfa647c809cf3c9fde453abcfc6dc42e01806409202b915dba08013"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9841ad1fd59741555e6209c7259e152e9ec354cbc4514e41377460008baf0c6b"
  end

  depends_on "curl"
  depends_on "openssl@3"
  depends_on "python@3.12"

  conflicts_with "spotbugs", because: "both install a `fb` binary"

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/c9/5a/e68b8abbc1102113b7839e708ba04ef4c4b8b8a6da392832bb166d09ea72/pycurl-7.45.3.tar.gz"
    sha256 "8c2471af9079ad798e1645ec0b0d3d4223db687379d17dd36a70637449f81d6b"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  def install
    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install resources

    rw_info = python_shebang_rewrite_info(libexec/"bin/python")
    rewrite_shebang rw_info, "fb"

    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"fb", "-h"
  end
end
