class Mitie < Formula
  desc "Library and tools for information extraction"
  homepage "https://github.com/mit-nlp/MITIE/"
  url "https://github.com/mit-nlp/MITIE/archive/v0.7.tar.gz"
  sha256 "0830955e64c2a4cceab803884355f090cf8e9086e68ac5df43058f05c34697e8"
  license "BSL-1.0"
  revision 2
  head "https://github.com/mit-nlp/MITIE.git"

  bottle do
    cellar :any
    sha256 "26424cf75f07bf9970c4a5ef979b33f9bffdbcf8b98bdda56759f7b49ed3757d" => :big_sur
    sha256 "49066ada52cbf94e095569f97b8d629f2e54b19fa4dfcffbc4ad12bf3728e656" => :arm64_big_sur
    sha256 "7190df4ed270f1ed0d6b09ea3410b673af9bf8de7349db5cc7c58a8596d10094" => :catalina
    sha256 "523dbdb69c94746e8e451c01a400897e294f414981bacc7c3933e3cefef590c5" => :mojave
    sha256 "36a3671f823322c4542af4c555ccfcc1f69ce7c50360f17903b0decc34ddb63e" => :high_sierra
  end

  depends_on "python@3.9"

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
