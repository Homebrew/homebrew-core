class Clinfo < Formula
  desc "Print information about OpenCL platforms and devices"
  homepage "https://github.com/Oblomov/clinfo"
  url "https://github.com/Oblomov/clinfo/archive/3.0.20.11.20.tar.gz"
  sha256 "3c506083e72e9ee09fc7d5de513be7c5eff0284f198a60fb60ab493f6f0a549a"
  license "CC0-1.0"
  head "https://github.com/Oblomov/clinfo.git"

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "cafa2a5a349c8bee91179744247b919511793ffa28093067da0beff77d836345" => :big_sur
    sha256 "c82664d00970694fe99c93ddaae4ee9f773826094bade686111e975262577adc" => :catalina
    sha256 "e9b1ab0c1a02a4a35db288c91d3818801d0407f8ceee0d2a51ad98895c7a8871" => :mojave
  end

  def install
    system "make", "MANDIR=#{man}", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match /Device Type +CPU/, shell_output(bin/"clinfo")
  end
end
