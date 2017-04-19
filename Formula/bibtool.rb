class Bibtool < Formula
  desc "BibTeX library manager"
  homepage "http://www.gerd-neugebauer.de/software/TeX/BibTool/en/"
  url "http://mirrors.ctan.org/biblio/bibtex/utils/bibtool/BibTool-2.65.tar.gz"
  sha256 "8469c37a1ae0b39af19a54f1f6c607af067430c4591319ae6e2a61d6a7d239f7"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    (testpath/"test.bib").write <<-EOS.undent
          @Article{foo14,
            author	= {Foo, Bar},
            title		= {{Analysis on Foo Bar}},
            year		= {2014}
          }
          @Article{baz06,
            author	= {Baz, Bar},
            title		= {{Analysis on Foo Bar}},
            year		= {2006}
          }
        EOS
    system "bibtool", "-s", "test.bib"
  end
end
