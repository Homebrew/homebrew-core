class Mitie < Formula
  desc "Library and tools for information extraction"
  homepage "https://github.com/mit-nlp/MITIE/"
  url "https://github.com/mit-nlp/MITIE/archive/v0.5.tar.gz"
  sha256 "324b7bddedea13cebab0bc0fe9f8d5cfb7bfaf26eac5aa3aae1e74afa909aa12"

  head "https://github.com/mit-nlp/MITIE.git"

  bottle do
    cellar :any
    sha256 "bc18dec586f4875fcb6272323a61007ad0485cd846e9ad18f60b8239c0337505" => :high_sierra
    sha256 "fc24dd3da4e0850a60ba6d273ff17eade8a955580aeb91584410efadb29734b2" => :sierra
    sha256 "107bc6325dc1404d1bfe09d400db80b8892e268626d52152c004e79642ee6421" => :el_capitan
    sha256 "4570f1e2ac9721e5f53beda0d3e6be2ab88604e490641273b2959424fdf095a2" => :yosemite
    sha256 "55220ba374b6b03316fd757d2731e8745aa8be50ddc983e0fd28e04bdf5f26da" => :mavericks
    sha256 "25a3ca7c81987f46cb52f4cc8b8c8de674db5c232d9b6e8383d376fad00ae3ea" => :mountain_lion
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
