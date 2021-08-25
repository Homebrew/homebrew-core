class Polyml < Formula
  desc "Standard ML implementation"
  homepage "https://www.polyml.org/"
  url "https://github.com/polyml/polyml/archive/v5.8.2.tar.gz"
  sha256 "310b0ba748a50f38e99de7f65ba990bc4b4f4b0123ad76aba4c44d7cd1ed9277"
  license "LGPL-2.1"
  head "https://github.com/polyml/polyml.git", branch: "master"

  bottle do
    sha256 big_sur:      "4b68c9e84f40360b1b65444949637bb1f5749f532ad198a44f3bb570854b9900"
    sha256 catalina:     "1517e342bf9c4569b986d1139c063e14a999cacb29597e53e438040090e93424"
    sha256 mojave:       "fccbd2fc3c3570178c8578475035fbee24ab9280a3366a82b797c1fb7627c588"
    sha256 x86_64_linux: "d356087174d4a1031bbacaac76dfcb1735d613a55510ff8b0207ea6d53994038"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"hello.ml").write <<~EOS
      let
        fun concatWithSpace(a,b) = a ^ " " ^ b
      in
        TextIO.print(concatWithSpace("Hello", "World"))
      end
    EOS
    assert_match "Hello World", shell_output("#{bin}/poly --script hello.ml")
  end
end
