class Polyml < Formula
  desc "Standard ML implementation"
  homepage "http://www.polyml.org"
  url "https://github.com/polyml/polyml/archive/v5.7.1.tar.gz"
  sha256 "d18dd824b426edaed1cec71dded354b57df9ebdbd38863bc7540a60bd0667028"
  head "https://github.com/polyml/polyml.git"

  bottle do
    sha256 "5a1f478b3b2b26ab1f2326031c5ea930aa97ac08b83881151e976942c674df65" => :high_sierra
    sha256 "d4c027b336791cc932cebddb6ea901af8a17f482511e9858a4766b380a1b3391" => :sierra
    sha256 "5adaaa6d45b674090dd49918532a5035737e7d7d2a1acf861a053ac96d297596" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
