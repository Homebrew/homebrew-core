class Feedgnuplot < Formula
  desc "Tool to plot realtime and stored data from the command-line."
  homepage "https://github.com/dkogan/feedgnuplot"
  url "https://github.com/dkogan/feedgnuplot/archive/v1.43.tar.gz"
  sha256 "12dc5382595a37a0a7ded37ad782a74d4be8da01189251d4a80d2fa16759f05a"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee19ef910e97192ba88de7568c22bd13212dcd4ee07b5dfce554334afe611bde" => :sierra
    sha256 "4ea602edb3fad45933bdbc7cbf9dc45f89ae6c3e541c5f106adf21ea15d0b4ca" => :el_capitan
    sha256 "d04b40527bb61a7ece91613353d192ade2766109fd4e77a98ae67830414a60ed" => :yosemite
  end

  depends_on "gnuplot"

  def install
    system "perl", "Makefile.PL", "prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    pipe_output("#{bin}/feedgnuplot --terminal 'dumb 80,20' --exit", "seq 5", 0)
  end
end
