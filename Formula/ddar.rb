class Ddar < Formula
  desc "De-duplicating archiver"
  homepage "https://github.com/basak/ddar"
  url "https://github.com/basak/ddar/archive/v1.0.tar.gz"
  sha256 "b95a11f73aa872a75a6c2cb29d91b542233afa73a8eb00e8826633b8323c9b22"
  revision 3

  head "https://github.com/basak/ddar.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a61743eeb3c427b89e14352c378c43a63e9b6fdbfde36abddc0431037967a7e5" => :el_capitan
    sha256 "c236979b7a4a231cb85265684a88f76ef475f60d4176b7eed0e14bf4cd338ead" => :yosemite
    sha256 "836ef59d9bd6a1d92536c5ee215152deb29db46acbfe2170c8318e90f4dffea5" => :mavericks
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
