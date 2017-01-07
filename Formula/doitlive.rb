class Doitlive < Formula
  desc "Replay stored shell commands for live presentations"
  homepage "https://doitlive.readthedocs.io/en/latest/"
  url "https://pypi.python.org/packages/81/79/ef8a1e4d66dacd35dad49eec8304873b7608d5146ef9cf849679b2757739/doitlive-2.6.0.tar.gz"
  sha256 "e3f577f8e0de03cf1431f5bd1482778d149f6061c8167cbe6abfdcc3b9a5a619"

  bottle do
    cellar :any_skip_relocation
    sha256 "668a95dc3b3b49b6f9f7838684083faf6f12569bcc6614aa9a2c4375411e2148" => :sierra
    sha256 "7511278488a6526d67ae4a2aed6f30f82b376fb37481fac9e95739675cc54091" => :el_capitan
    sha256 "1f57f0702e75092cf0b96156181cff026ee0e3a72c492fc0ed24899d20ad9b3d" => :yosemite
    sha256 "8be17aac97bb36b09759bee0eee85c264274c642033f895d4828997541df7f17" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"
    system "python", "setup.py", "install", "--prefix=#{libexec}"

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/doitlive", "themes", "--preview"
  end
end
