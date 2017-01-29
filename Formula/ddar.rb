class Ddar < Formula
  desc "De-duplicating archiver"
  homepage "https://github.com/basak/ddar"
  url "https://github.com/basak/ddar/archive/v1.0.tar.gz"
  sha256 "b95a11f73aa872a75a6c2cb29d91b542233afa73a8eb00e8826633b8323c9b22"
  revision 4

  head "https://github.com/basak/ddar.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f67f2b0cc120f77faeddea7b110d20fe07d704f39b1dde8dd22e3797fb1a2b34" => :sierra
    sha256 "fc95482e4b3e32bedf27cc374cb393495ef9698b4ae297282de0ed6360c5c921" => :el_capitan
    sha256 "f4d6892bbe9d74535d160ea50240aa976764f838c62d125343c3db2383eee2a9" => :yosemite
  end

  depends_on "xmltoman" => :build
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "protobuf"

  def install
    system "make", "-f", "Makefile.prep", "pydist"
    system "python", "setup.py", "install",
                     "--prefix=#{prefix}",
                     "--single-version-externally-managed",
                     "--record=installed.txt"

    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    man1.install Dir["*.1"]
  end
end
