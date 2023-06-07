class LcdfTypetools < Formula
  desc "Manipulate OpenType and multiple-master fonts"
  homepage "https://www.lcdf.org/type/"
  url "https://www.lcdf.org/type/lcdf-typetools-2.108.tar.gz"
  sha256 "fb09bf45d98fa9ab104687e58d6e8a6727c53937e451603662338a490cbbcb26"
  license "GPL-2.0-or-later"
  head "https://github.com/kohler/lcdf-typetools.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?lcdf-typetools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "4a3eed405c90e63d9b545828b1be31f3058090a13df8c6bdc7b20b4df385234f"
    sha256 arm64_monterey: "a0d7a6e2b9be3e584f4dcacb653e751ffaf57480b599c485700df330e53763fe"
    sha256 arm64_big_sur:  "bea41132d0d057aef10d64fe53b52bb198c3ce49b8548c72d5430f1411f68afe"
    sha256 ventura:        "628ab26912469dbe132996144e44c19774f6eaf2618e6bea9dd4a4c375a37f34"
    sha256 monterey:       "70e227962b9890b989234cf6d8b2faf7ec10bb1a2bd3f3f8cd6306ae07b75858"
    sha256 big_sur:        "45ff77c662edb2a238d2c07be58cf242685ed85c926847a381e9a2acf7035b3a"
    sha256 catalina:       "e7ce2d4d16d2b79e482cb862231519653e6d3c09cd5e310573b04f804323e1e3"
    sha256 mojave:         "0fd983396dbcf027e560753e6f25797500d085762edcf59a1a2034cd55c24cfd"
    sha256 high_sierra:    "cdff1c16d03fd920033f85dd2e2180f91791057729fbd26b6f193ac7cd0ce9f4"
    sha256 sierra:         "2bfe28f9e869eec676cada56bcf6efe97024e0e1f93b126a7b26ac2a292db2af"
    sha256 x86_64_linux:   "ba34cee40d5450d1deba4434cc43458d5407ef47b9f0563530b04dfac8fadc7a"
  end

  conflicts_with "texlive", because: "both install a `cfftot1` executable"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-kpathsea"
    system "make", "install"
  end

  test do
    if OS.mac?
      font_name = (MacOS.version >= :catalina) ? "Arial Unicode" : "Arial"
      font_dir = "/Library/Fonts"
    else
      font_name = "DejaVuSans"
      font_dir = "/usr/share/fonts/truetype/dejavu"
    end
    assert_includes shell_output("#{bin}/otfinfo -p '#{font_dir}/#{font_name}.ttf'"), font_name.delete(" ")
  end
end
