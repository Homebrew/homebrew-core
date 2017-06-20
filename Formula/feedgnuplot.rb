class Feedgnuplot < Formula
  desc "Tool to plot realtime and stored data from the command-line."
  homepage "https://github.com/dkogan/feedgnuplot"
  url "https://github.com/dkogan/feedgnuplot/archive/v1.43.tar.gz"
  sha256 "12dc5382595a37a0a7ded37ad782a74d4be8da01189251d4a80d2fa16759f05a"

  bottle do
    cellar :any_skip_relocation
    sha256 "95118a4ffc658233fa94a797a1871fe608d904eed46bb8ff083a6567a96839ad" => :sierra
    sha256 "88403976786ae5c9cc9885fb3c0d26bd6019fa705411c368534868dee21ce292" => :el_capitan
    sha256 "66c40413745ae8f0677f194176830447d138c0ca2b250d2398d213325f5e206e" => :yosemite
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
