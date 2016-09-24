class Ddar < Formula
  desc "De-duplicating archiver"
  homepage "https://github.com/basak/ddar"
  url "https://github.com/basak/ddar/archive/v1.0.tar.gz"
  sha256 "b95a11f73aa872a75a6c2cb29d91b542233afa73a8eb00e8826633b8323c9b22"
  revision 3

  head "https://github.com/basak/ddar.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6dc73565cbce9b13c28eb942088faad6506d0e3b8d5421acd54019be39bf0076" => :sierra
    sha256 "2c63eb7e5c93cd986432fe26484ab1e9c74e8ce6b156cf5e30d14fb104b012ad" => :el_capitan
    sha256 "bfa2b94bc078c69736d163227a6cfc83889eeda661125c2921cfea2e663b5a46" => :yosemite
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
