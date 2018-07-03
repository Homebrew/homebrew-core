class Bibutils < Formula
  desc "Bibliography conversion utilities"
  homepage "https://sourceforge.net/p/bibutils/home/Bibutils/"
  url "https://downloads.sourceforge.net/project/bibutils/bibutils_6.6_src.tgz"
  sha256 "fa9ef12e6ecf756183a7ee0442552d58ceba973067342b6efbd4d967b5841cff"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f58a850b653e20bd0aa8ef919762050f7a6b0061602566637ddd1a45280885d" => :high_sierra
    sha256 "4f9f8b05da2df7fbc63823e53d18fea3138b8a4e28c57cdbfaf9373c44b5bbe1" => :sierra
    sha256 "9cae6b82e47b282eb82105a6918998c052e28b121720182f7210c5393eceddd1" => :el_capitan
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
