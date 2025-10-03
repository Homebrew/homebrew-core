class Depqbf < Formula
  desc "Solver for quantified boolean formulae (QBF)"
  homepage "https://lonsing.github.io/depqbf/"
  url "https://github.com/lonsing/depqbf/archive/refs/tags/version-6.03.tar.gz"
  sha256 "9684bb1562bfe14559007401f52975554373546d3290a19618ee71d709bce76e"
  license "GPL-3.0-or-later"
  head "https://github.com/lonsing/depqbf.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "5494cf1ffc209c33da83751528490bb7b8324e9cfde890d66231916ffa9c9eb9"
    sha256 cellar: :any,                 arm64_sequoia:  "77fb774ec31c1de16c6136751d66b3cb04d9a7bf0e2fb8c4e51a56db412310c4"
    sha256 cellar: :any,                 arm64_sonoma:   "dce4afe9355597c29c7656a5fcdda35983fe58b95ae72e966a6967a0360dd9d1"
    sha256 cellar: :any,                 arm64_ventura:  "221268b1bc924d55e1f8f3554b85f4ae91475792834f699217b03cce46ea63a3"
    sha256 cellar: :any,                 arm64_monterey: "204b1a36f581b9609dcf0a47c0778169d0f26748e6a5fd869a1e7bba826be6f8"
    sha256 cellar: :any,                 arm64_big_sur:  "afc477a7b941f95abf0a3e7db86d60b2ee9ef9e8b2f4ecb84d84044a9dbb0bdf"
    sha256 cellar: :any,                 sonoma:         "2417e97e2936f086ff114fd6658d2c717a2a26a6541ef2ab2108a82200e324ee"
    sha256 cellar: :any,                 ventura:        "209da2f6f71ffd18105f99dd6333a0547865da8725e109138fe9e3e138b8300c"
    sha256 cellar: :any,                 monterey:       "135536ee418fef5b3e8002301dca15913770d3b2d81c8b08b9bb2fef67bb56cc"
    sha256 cellar: :any,                 big_sur:        "e86513b7cd6ad6ac68c7aa8a1738d8586fe6e20a7a46237dcbc3d54d735ff6d0"
    sha256 cellar: :any,                 catalina:       "432518e2ccee50695a9e79b4fe558142d78945ef96fcdbf7cccf090d72ec6543"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "27916b378549105a9812407772165660f12c3ac27be9af6995fd09f5bee27827"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e13e19078a40264180e470c713e834493e8189f3b45a263318f17d1b4830f73"
  end

  resource "nenofex" do
    url "https://github.com/lonsing/nenofex/archive/refs/tags/version-1.1.tar.gz"
    sha256 "972755fd9833c9cd050bdbc5a9526e2b122a5550fda1fbb3ed3fc62912113f05"
  end

  resource "picosat" do
    url "https://fmv.jku.at/picosat/picosat-960.tar.gz"
    sha256 "edb3184a04766933b092713d0ae5782e4a3da31498629f8bb2b31234a563e817"
  end

  def install
    (buildpath/"nenofex").install resource("nenofex")
    (buildpath/"picosat-960").install resource("picosat")
    system "./compile.sh"
    bin.install "depqbf"
    lib.install "libqdpll.a"
    if OS.mac?
      lib.install "libqdpll.1.0.dylib"
    else
      lib.install "libqdpll.so.1.0"
    end
  end

  test do
    system bin/"depqbf", "-h"
  end
end
