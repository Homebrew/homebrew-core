class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v2.1.11.tar.gz"
  sha256 "ec943ed8217aef2b4c599c7c0bba5137a609961df4e114b486169a581b9a50b5"
  head "https://github.com/tj/n.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "35ebc95ee76c7a59a53f9f2c4ab7843ffbb35a04adcefec996cf10357f7db5b0" => :high_sierra
    sha256 "35ebc95ee76c7a59a53f9f2c4ab7843ffbb35a04adcefec996cf10357f7db5b0" => :sierra
    sha256 "35ebc95ee76c7a59a53f9f2c4ab7843ffbb35a04adcefec996cf10357f7db5b0" => :el_capitan
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
