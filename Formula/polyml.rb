class Polyml < Formula
  desc "Standard ML implementation"
  homepage "https://www.polyml.org/"
  url "https://github.com/polyml/polyml/archive/v5.8.tar.gz"
  sha256 "6bcc2c5af91f361ef9e0bb28f39ce20171b0beae73b4db3674df6fc793cec8bf"
  head "https://github.com/polyml/polyml.git"

  bottle do
    sha256 "ac906a03567d473a5827a8c6ccb8dc12944e4c28ed85925d62fd09b8d2c401d9" => :mojave
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
