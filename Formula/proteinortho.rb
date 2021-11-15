class Proteinortho < Formula
  desc "Detecting orthologous genes within different species"
  homepage "https://gitlab.com/paulklemm_PHD/proteinortho"
  url "https://gitlab.com/paulklemm_PHD/proteinortho/-/archive/v6.0.31/proteinortho-v6.0.31.tar.gz"
  sha256 "4be913e0611a7383e2adcafc69dd47efc84a55e370be0bc1f5e0097be6d197b6"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "765899e2a19ba1d3db3aca66172946123ebfde61e1d33982f15af260b15792df"
    sha256 cellar: :any,                 monterey:      "a646a16c3c4127fb72ce2fae91fc774dd9462e22dec105464ace576c2eb046b7"
    sha256 cellar: :any,                 big_sur:       "c75afcf372564f4b5f22bbed0bcce9cdb7ec6fef91cd0fcf7e1aba153ecaaf32"
    sha256 cellar: :any,                 catalina:      "090b08218718cb955e4ee1044fc337394d9dc8f745eb83af5dbb4beb7615c153"
    sha256 cellar: :any,                 mojave:        "3861fa61d70fac1b647864001254a196fcd135f435af0d816a87c2605bb538e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cab957581addd7580770220acb61ea61e5a90e06542307c166db7b9d724f6359"
  end

  depends_on "diamond"
  depends_on "openblas"

  def install
    ENV.cxx11

    bin.mkpath
    system "make", "install", "PREFIX=#{bin}"
    doc.install "manual.html"
  end

  test do
    system "#{bin}/proteinortho", "-test"
    system "#{bin}/proteinortho_clustering", "-test"
  end
end
