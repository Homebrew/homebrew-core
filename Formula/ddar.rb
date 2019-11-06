class Ddar < Formula
  desc "De-duplicating archiver"
  homepage "https://github.com/basak/ddar"
  url "https://github.com/basak/ddar/archive/v1.0.tar.gz"
  sha256 "b95a11f73aa872a75a6c2cb29d91b542233afa73a8eb00e8826633b8323c9b22"
  revision 5
  head "https://github.com/basak/ddar.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "687493be4181a4b044d77df4fecf625d2c3f35537c2379ac2fb2923a3a66a554" => :catalina
    sha256 "fba182119e1413c6c6a38cd9d4571426685b39f290c3234d16f469f2ab455c78" => :mojave
    sha256 "f8fe594bc5a8628495e057b25bcb644b5799ac05ce1b7c0d85fd01ed8d77dc8e" => :high_sierra
    sha256 "3d9bd53fe084276e7e57ccbb4f4cadfef811182b487bc2e93dd4f373fd3784c5" => :sierra
    sha256 "3925167c1884bc6dc522d603f216671a897e86faa6eee6c9e34a2bbeaa2d4450" => :el_capitan
    sha256 "bb01afc3ebd42f46e00d00eddbcb8ae000ecbe50a19aa5512a84f7fab5faaf91" => :yosemite
  end

  depends_on "xmltoman" => :build
  depends_on "protobuf"
  depends_on "python@2" # does not support Python 3

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
