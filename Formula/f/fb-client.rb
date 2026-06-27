class FbClient < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Shell-script client for https://paste.xinu.at"
  homepage "https://paste.xinu.at"
  url "https://paste.xinu.at/data/client/fb-2.4.0.tar.gz"
  sha256 "a3dd5580c7ba459c18f2d2ac39614422fd9c0dccb4545dbd683c77104062af39"
  license "GPL-3.0-only"

  livecheck do
    url :homepage
    regex(%r{Latest release:.*?href=.*?/fb[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "94836e631e1cebba28bc3327d3cb63a2725af425a34949ea5b3d643b3e88a18b"
    sha256 cellar: :any,                 arm64_sequoia: "87c40285614876d05e7b8f4274ac5bb5b171d1cdcea2931eefc6d32ccd4f490d"
    sha256 cellar: :any,                 arm64_sonoma:  "059881236183d0a075ac3059e01eeb9be2546e82bcb8d6daa0e295ffb0d4971c"
    sha256 cellar: :any,                 sonoma:        "6af4054c808c8f5c3ec176d38dfe8fcedab2516ff410f9bf7d747afbf0520521"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa64e34d0861774bb7570f22b37fc37ca517d484f9c4d38307bd76d474b0ed44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dacaf9c2b823ba207783b95c773e5820ca391393b93cdf0c05f1cb7e993d86c"
  end

  depends_on "curl"
  depends_on "openssl@3"
  depends_on "python@3.14"

  conflicts_with "spotbugs", because: "both install a `fb` binary"

  pypi_packages package_name:   "",
                extra_packages: ["pycurl", "pyxdg"]

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/95/23/cc07b16591af8ca373494d29aafc8df13e547077579e6779bb865a3f5a7f/pycurl-7.46.0.tar.gz"
    sha256 "422ed7005b98768fe60fe6b6cb8bb6a4e1fc18b5433402e8fbdaba91811c4604"
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
