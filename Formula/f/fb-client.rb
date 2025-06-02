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
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "ff32b0378ba41c1395804519b388c315d0abe780848adbd49ee764358047f81f"
    sha256 cellar: :any,                 arm64_sonoma:  "e62bc0b15dc4557b1a68a5caacd45eb055110af29cdbb799f0577c712aa9696f"
    sha256 cellar: :any,                 arm64_ventura: "a0ccd6e897f9815ac195bee9550634463b55375faddb81d4ecb48d880e955058"
    sha256 cellar: :any,                 sonoma:        "fe1df6af7eee1f28991e794c5545b3d54d26a21b89f90b80a0d3434fd4e538d1"
    sha256 cellar: :any,                 ventura:       "ec38a067c8f05eb8e1e1ffd6779ba60b893ddc811bb41ea30333cef3b6ea5c44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a95aba0e62e7e34d96cd40dd975a103f0a2d98379dcf2f6ee24fe7367bdadbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38fff3cbf77d6edd4773fbf6d57e1901a5032428248ffd6a258a2544a6762ebf"
  end

  depends_on "curl"
  depends_on "openssl@3"
  depends_on "python@3.13"

  conflicts_with "spotbugs", because: "both install a `fb` binary"

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/71/35/fe5088d914905391ef2995102cf5e1892cf32cab1fa6ef8130631c89ec01/pycurl-7.45.6.tar.gz"
    sha256 "2b73e66b22719ea48ac08a93fc88e57ef36d46d03cb09d972063c9aa86bb74e6"
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
