class Bibutils < Formula
  desc "Bibliography conversion utilities"
  homepage "https://sourceforge.net/p/bibutils/home/Bibutils/"
  url "https://downloads.sourceforge.net/project/bibutils/bibutils_6.10_src.tgz"
  sha256 "8656c042fa1371443aa4e1a58bcab5fcea0b236eb39182e4004fc348ce56e496"
  license "GPL-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/bibutils[._-]v?(\d+(?:\.\d+)+)[._-]src\.t}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "2c80f9ec43e7cc9eef54326523a45b908a791fea211bb3304659cd4032c8f006" => :big_sur
    sha256 "c9d3274c2d4d3a340f0c7032d5d2b47e9e4e25327ea00082f260cca3eb76aa95" => :arm64_big_sur
    sha256 "eeb586f94730c9030e089a45e4360c5cb3171c6e41ba738744fe4e5a30e31cb7" => :catalina
    sha256 "f420f3882e82a0bf4441c804ed065b5272ce1e5d03812392534d91b29814cd13" => :mojave
    sha256 "4fb4ed2978195afedc30fff98661e2663120bd956633845b7e41967dd7a28621" => :high_sierra
  end

  def install
    system "./configure", "--install-dir", bin,
                          "--install-lib", lib
    system "make", "install", "CC=#{ENV.cc}"
  end

  test do
    (testpath/"test.bib").write <<~EOS
      @article{Homebrew,
          title   = {Something},
          author  = {Someone},
          journal = {Something},
          volume  = {1},
          number  = {2},
          pages   = {3--4}
      }
    EOS

    system "#{bin}/bib2xml", "test.bib"
  end
end
