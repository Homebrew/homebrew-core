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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_tahoe:   "d8e28f243d35b05f844423d91864d16f6a762c9f504f275b844dd6b9a30e7cae"
    sha256 cellar: :any,                 arm64_sequoia: "847de16c9a66787cd02c39cb7d3fe9d2b525d35c14c994b65897340c72c9ef9c"
    sha256 cellar: :any,                 arm64_sonoma:  "979dc4765686977ab283f64a2cc5d9a2e11b29aa77429a1e10cff91d26d3710b"
    sha256 cellar: :any,                 sonoma:        "8b4e5071281484647dc85aacd08e852e801300efc81a10020244a33682913c1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25a09e67f190d6b0fb898ff38b44fdae32c068f1710b240d1e2591cdd4c8c9d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "710a8cfa181a40cf624baf02e392d55a72420764bff738d2e400ad099dc9dbca"
  end

  depends_on "curl"
  depends_on "openssl@3"
  depends_on "python@3.14"

  conflicts_with "spotbugs", because: "both install a `fb` binary"

  pypi_packages package_name:   "",
                extra_packages: ["pycurl", "pyxdg"]

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/e3/3d/01255f1cde24401f54bb3727d0e5d3396b67fc04964f287d5d473155f176/pycurl-7.45.7.tar.gz"
    sha256 "9d43013002eab2fd6d0dcc671cd1e9149e2fc1c56d5e796fad94d076d6cb69ef"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  def install
    venv = virtualenv_create(libexec, "python3.14")
    venv.pip_install resources

    rw_info = python_shebang_rewrite_info(libexec/"bin/python")
    rewrite_shebang rw_info, "fb"

    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"fb", "-h"
  end
end
