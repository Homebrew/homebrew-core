class Eprover < Formula
  desc "Theorem prover for full first-order logic with equality"
  homepage "https://eprover.org/"
  url "https://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/V_3.2/E.tgz"
  sha256 "074c8e5fc3062476341ce790fd15ad8004d322d6b6627844bd2768a8830bd4ae"
  license any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url "https://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/"
    regex(%r{href=.*?V?[._-]?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c01a004aee61d877eecbb457c34217d181e560455e5c70faaaaaecb3d753d59c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "223a449ee66977e8d1dcbb7754ae3abdb46f22fc543ce0649051b720c23a2586"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f690b2f275b3a37b8ab622efae78bfa9170f40cbcf46cb3750efe63d6a471838"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6fe61cbeabd5935b6f020064ab65bd93b36cf4c69069ec207fdfd29db08026cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "4211bca5c7075d8a387d3a3f112270bde241a9f7e9621cdf631224d67b21a55f"
    sha256 cellar: :any_skip_relocation, ventura:       "0bbb0c7af2039115ab05e98ee1b355fe4f33610d1940ad560b824cbcacabf9e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8787c5f0cb13c1ca7093aab86bcb2e80e03b321faeacddd0ed325c2f1ab7a55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9938d476044c8d9a8733cd3e0417f42aecdb488ce719f3c2eabf32d151dbd6ba"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--man-prefix=#{man1}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"eprover", "--help"
  end
end
