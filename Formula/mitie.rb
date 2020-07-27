class Mitie < Formula
  desc "Library and tools for information extraction"
  homepage "https://github.com/mit-nlp/MITIE/"
  url "https://github.com/mit-nlp/MITIE/archive/v0.7.tar.gz"
  sha256 "0830955e64c2a4cceab803884355f090cf8e9086e68ac5df43058f05c34697e8"
  license "BSL-1.0"
  revision 1
  head "https://github.com/mit-nlp/MITIE.git"

  bottle do
    cellar :any
    sha256 "194f53bc1f0f2bcc8c833d486229cb960c33705b389d7e83d0edf0afb14756eb" => :catalina
    sha256 "f433ff3785259a3ca1a76066ac500639cf8bfe80cb5e327b3ff0a5345ec27442" => :mojave
    sha256 "4ca2709376e8a37abe3a3f2763b698489b79fb2ff3c65d6845cbd2aefa9a2e9b" => :high_sierra
  end

  depends_on "python@3.8"

  resource "models-english" do
    url "https://downloads.sourceforge.net/project/mitie/binaries/MITIE-models-v0.2.tar.bz2"
    sha256 "dc073eaef980e65d68d18c7193d94b9b727beb254a0c2978f39918f158d91b31"
  end

  def install
    (share/"MITIE-models").install resource("models-english")

    inreplace "mitielib/makefile", "libmitie.so", "libmitie.dylib"
    system "make", "mitielib"
    system "make"

    include.install Dir["mitielib/include/*"]
    lib.install "mitielib/libmitie.dylib", "mitielib/libmitie.a"

    xy = Language::Python.major_minor_version "python3"
    (lib/"python#{xy}/site-packages").install "mitielib/mitie.py"
    pkgshare.install "examples", "sample_text.txt",
                     "sample_text.reference-output",
                     "sample_text.reference-output-relations"
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
