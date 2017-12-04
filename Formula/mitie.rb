class Mitie < Formula
  desc "Library and tools for information extraction"
  homepage "https://github.com/mit-nlp/MITIE/"
  url "https://github.com/mit-nlp/MITIE/archive/v0.5.tar.gz"
  sha256 "324b7bddedea13cebab0bc0fe9f8d5cfb7bfaf26eac5aa3aae1e74afa909aa12"

  head "https://github.com/mit-nlp/MITIE.git"

  bottle do
    cellar :any
    sha256 "d73f3db219902d12a9321273adb0be485156d870e43cbf0106db550cef210cbe" => :high_sierra
    sha256 "e3776d82c4712cd1532a2a54456e61c67f08b23b90ef946d475952dc4cb0f308" => :sierra
    sha256 "de7e18c61774eff595acafeeaa22733c13269face211a179f3a46c0b6aa7dc60" => :el_capitan
  end

  option "without-models", "Don't download the v0.2 models (~415MB)"

  depends_on :python if MacOS.version <= :snow_leopard

  resource "models-english" do
    url "https://downloads.sourceforge.net/project/mitie/binaries/MITIE-models-v0.2.tar.bz2"
    sha256 "dc073eaef980e65d68d18c7193d94b9b727beb254a0c2978f39918f158d91b31"
  end

  def install
    if build.with? "models"
      (share/"MITIE-models").install resource("models-english")
    end

    inreplace "mitielib/makefile", "libmitie.so", "libmitie.dylib"
    system "make", "mitielib"
    system "make"

    include.install Dir["mitielib/include/*"]
    lib.install "mitielib/libmitie.dylib", "mitielib/libmitie.a"
    (lib/"python2.7/site-packages").install "mitielib/mitie.py"
    pkgshare.install "examples", "sample_text.txt",
      "sample_text.reference-output", "sample_text.reference-output-relations"
    bin.install "ner_example", "ner_stream", "relation_extraction_example"
  end

  test do
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lmitie",
           pkgshare/"examples/C/ner/ner_example.c",
           "-o", testpath/"ner_example"
    system "./ner_example", share/"MITIE-models/english/ner_model.dat",
           pkgshare/"sample_text.txt"
  end
end
