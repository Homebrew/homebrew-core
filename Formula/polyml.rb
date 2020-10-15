class Polyml < Formula
  desc "Standard ML implementation"
  homepage "https://www.polyml.org/"
  url "https://github.com/polyml/polyml/archive/v5.8.1.tar.gz"
  sha256 "fa0507b44470b4e07a061ef6a8896efe42710d8436e15721d743572ad2f7753b"
  license "LGPL-2.1"
  head "https://github.com/polyml/polyml.git"

  bottle do
    sha256 "22f583ec73be6a469af9adff8eb3e3bc7b7ad7b40db56c16a91569f3d2097dbc" => :catalina
    sha256 "65a6a917d00e9bfb09705833ac96584f3e503edb3342c7203b083f17c8103d97" => :mojave
    sha256 "1f0d015938e838043ab26bffb144a2abe0cf5ad5944514c1a8497d79f02dbede" => :high_sierra
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
