class Docutils < Formula
  desc "Text processing system for reStructuredText"
  homepage "https://docutils.sourceforge.io"
  url "https://downloads.sourceforge.net/project/docutils/docutils/0.20.1/docutils-0.20.1.tar.gz"
  sha256 "f08a4e276c3a1583a86dce3e34aba3fe04d02bba2dd51ed16106244e8a923e3b"
  license all_of: [:public_domain, "BSD-2-Clause", "GPL-3.0-or-later", "Python-2.0"]

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2f08fe34b2bc93a4213c1e7c762b62a215f9d64d91841898ddac19643e2af418"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "86fb46edc7859129fd319ec6d63aa3bf29383fdb51f96aa3ef466f97b13ca8a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cdb9692e679f6f477986b265ce0cc47c32513067761aebd4b01accbd7bfdad4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab511781e0dda714dd2a7c6762bcfbd24cf31a40af63349607d8efd2d810a588"
    sha256 cellar: :any_skip_relocation, sonoma:         "8375a10a9a25b5331ad55e7b0c0eebeed7a2bb2862b258a8d373fe8274353c2b"
    sha256 cellar: :any_skip_relocation, ventura:        "510eb4b5aa120cb0c6b3a3d11be6150ef5b52c1500225c0bc68263112a42755e"
    sha256 cellar: :any_skip_relocation, monterey:       "baef0621bdbcdbfbb2a3e407d54b533010f021a4b9f78a3e978e22ad0cbaf727"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c6107d3abb89359e378110485db98076b41f6a08c36d7b2643efaaace94991e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f62e7d49f5e36fc8b2621c919f0d531d1f9e1d29c7c18edb1076f34865f3c6e8"
  end

  depends_on "python@3.11"

  def python3
    which("python3.11")
  end

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."

    bin.glob("*.py") do |f|
      bin.install_symlink f => f.basename(".py")
    end
  end

  test do
    cp prefix/"README.txt", testpath
    mkdir_p testpath/"docs"
    touch testpath/"docs"/"header0.txt"
    system bin/"rst2man.py", testpath/"README.txt"
    system bin/"rst2man", testpath/"README.txt"
  end
end
