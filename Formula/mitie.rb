class Mitie < Formula
  desc "Library and tools for information extraction"
  homepage "https://github.com/mit-nlp/MITIE/"
  url "https://github.com/mit-nlp/MITIE/archive/v0.6.tar.gz"
  sha256 "bcfa6aab057206a2f5eeacbefa27a3205fe3bd906a54e0e790df3448b1c73243"
  head "https://github.com/mit-nlp/MITIE.git"

  bottle do
    cellar :any
    sha256 "ef09cd417f33606fdcdfa69621707e072a4e2909c46d44781b4c3eabafb63085" => :mojave
    sha256 "b491ebce36c1b523895db335a31ed4fd1b1e203a267037c9837da12d030ce0fd" => :high_sierra
    sha256 "b2813c1046c67800ff73f187d22c1d7d63aa9d6c8736606e69f2be5d3102ccee" => :sierra
  end

  depends_on "python@2"

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
