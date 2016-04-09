class Ddar < Formula
  desc "De-duplicating archiver"
  homepage "https://github.com/basak/ddar"
  url "https://github.com/basak/ddar/archive/v1.0.tar.gz"
  sha256 "b95a11f73aa872a75a6c2cb29d91b542233afa73a8eb00e8826633b8323c9b22"
  revision 1

  head "https://github.com/basak/ddar.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c22e97818c72ef55b1e7b24c3f56c80e3b6a8ec93598d60de3164e38bbb3d8bc" => :el_capitan
    sha256 "a23f1ac95b2c9ba9fd4321144bb4d58bfd65310de2a7172ea113d74813a276b1" => :yosemite
    sha256 "1903942f0c585ea54ad25eabc045d73dc499e99ba20b8bdd240e99e2dda326a6" => :mavericks
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
