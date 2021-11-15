class Ncdu < Formula
  desc "NCurses Disk Usage"
  homepage "https://dev.yorhel.nl/ncdu"
  url "https://dev.yorhel.nl/download/ncdu-1.16.tar.gz"
  sha256 "2b915752a183fae014b5e5b1f0a135b4b408de7488c716e325217c2513980fd4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68eb33234f67d014f1bb2edfd2750df4b96398af51063b135dd7c19de2caa8ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "110f61c5159ce8982f2086aebd7e55a1631c958c88fd69eec611242a83bd4577"
    sha256 cellar: :any_skip_relocation, monterey:       "d99f3365fc9733b3274b45e6312b933fea3847e89f0bcef401ed10805c35e5d7"
    sha256 cellar: :any_skip_relocation, big_sur:        "af3c3320ea08a93b0cb7bd260a297305d7c0283f8a9881971ecfa2dcb5c270b0"
    sha256 cellar: :any_skip_relocation, catalina:       "b201c2573ed203bbd41c801be8d0b63045e33b36b601bcf6b8c03b5598c9301f"
    sha256 cellar: :any_skip_relocation, mojave:         "4f0851785b40c0035a3d60687bdb180d46f8ec364508220c36bc40dda90ba25f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48c1a3244bf54b0ea5246bfa45130f18710f4943a30b897c9c104435585d26ca"
  end

  head do
    url "https://g.blicky.net/ncdu.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  uses_from_macos "ncurses"

  def install
    system "autoreconf", "-i" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ncdu -v")
  end
end
