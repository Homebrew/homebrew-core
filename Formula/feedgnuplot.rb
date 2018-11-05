class Feedgnuplot < Formula
  desc "Tool to plot realtime and stored data from the command-line"
  homepage "https://github.com/dkogan/feedgnuplot"
  url "https://github.com/dkogan/feedgnuplot/archive/v1.51.tar.gz"
  sha256 "fac4ab7716985c3e2a13ab2dc43cc8521e756925d3149c430cef2d79d34eb7e6"

  bottle do
    cellar :any_skip_relocation
    sha256 "a110bb9aa01cc9e352c908ad3b2fdb28029d6e7ea3f8d45eae345aef4d0a589f" => :mojave
    sha256 "ef4a25e38b3656db1be3b63712bac835e916ea83dd573fca0d7d2c2edd044f58" => :high_sierra
    sha256 "af0d98b77eaa98406a1e658482864e0e8496c49df143bc6f4b09f304cef15e20" => :sierra
    sha256 "24f425a74239db409524eab7e8252849d81342f8eb734c755d7906166c1d2870" => :el_capitan
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
