class Bibutils < Formula
  desc "Bibliography conversion utilities"
  homepage "https://sourceforge.net/p/bibutils/home/Bibutils/"
  url "https://downloads.sourceforge.net/project/bibutils/bibutils_6.5_src.tgz"
  sha256 "41143ccd9a3082e51dd59fa08131193108917c92f0c1bc890f8cadee6d5a852d"

  bottle do
    cellar :any_skip_relocation
    sha256 "d024f7274e55bd68c74540f0f928381c23edfd98addde2eda5003bf3fe2acb88" => :high_sierra
    sha256 "d430dfaf6c3b93738d2d4088d17a391cbf2947a7602ea87efd3099051ad9b828" => :sierra
    sha256 "5d781a61a07d635ce62b61e15997109316b8936d48b15674461da3756fcb4b4d" => :el_capitan
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
