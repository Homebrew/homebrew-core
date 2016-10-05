class Doitlive < Formula
  desc "Replay stored shell commands for live presentations"
  homepage "https://doitlive.readthedocs.io/en/latest/"
  url "https://pypi.python.org/packages/b0/a3/a6e67dcc4b83fd64bf8ab1429645ee2693e639a7d253fc1cdd7ab3badd99/doitlive-2.5.0.tar.gz"
  sha256 "5113e17e0c9f9f1712cd86e5e77fcad9408c7b6db464d5cf8565a10b6dd85bb6"

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
