class Bibutils < Formula
  desc "Bibliography conversion utilities"
  homepage "https://sourceforge.net/p/bibutils/home/Bibutils/"
  url "https://downloads.sourceforge.net/project/bibutils/bibutils_6.6_src.tgz"
  sha256 "fa9ef12e6ecf756183a7ee0442552d58ceba973067342b6efbd4d967b5841cff"

  bottle do
    cellar :any_skip_relocation
    sha256 "a581c2b50f0bb4ad8283f4b9532fe9286e070ce2d7e3c647a8a1814a413f8cbb" => :high_sierra
    sha256 "d02d33109d07ed474183d0f39bfa279fdb89e10a7e860a4c912133a06e85c646" => :sierra
    sha256 "a884cc6ce27c6f8ec6f8107e7a9c5b19345e3fd84d3b3c3ef65231ab5f17b7cc" => :el_capitan
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
