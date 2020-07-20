class Polyml < Formula
  desc "Standard ML implementation"
  homepage "https://www.polyml.org/"
  url "https://github.com/polyml/polyml/archive/v5.8.1.tar.gz"
  sha256 "fa0507b44470b4e07a061ef6a8896efe42710d8436e15721d743572ad2f7753b"
  license "LGPL-2.1"
  head "https://github.com/polyml/polyml.git"

  bottle do
    rebuild 1
    sha256 "1439f4258d7fa8adfab0b037ae43c5effaffd9b1c7793c05f73a0f130b65d403" => :catalina
    sha256 "356373c5c6483a552164e3aa815076688f37e41d74f8350a52321205f5d4547d" => :mojave
    sha256 "d69da52fe77cd77d079de8ba2b389ced34800cebf55202d023c6800d584a5212" => :high_sierra
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
