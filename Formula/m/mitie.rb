class Mitie < Formula
  desc "Library and tools for information extraction"
  homepage "https://github.com/mit-nlp/MITIE/"
  url "https://github.com/mit-nlp/MITIE/archive/refs/tags/v0.7.tar.gz"
  sha256 "0830955e64c2a4cceab803884355f090cf8e9086e68ac5df43058f05c34697e8"
  license "BSL-1.0"
  revision 3
  head "https://github.com/mit-nlp/MITIE.git", branch: "master"

  bottle do
    rebuild 5
    sha256 cellar: :any, arm64_golden_gate: "1ca2c42d4b8790ff3dac7d5b718198d0fe0e54b3813ce9c6e4f2716ac6138738"
    sha256 cellar: :any, arm64_tahoe:       "0dd6bab4c4a4a9870b4da5bebcf14a6a2837bdb36e7ec67e156b7ad8b72c370b"
    sha256 cellar: :any, arm64_sequoia:     "23d8154eeeb960958f53947bb3371496320b0303ede2982a05b6fa0306bce2f6"
    sha256 cellar: :any, arm64_linux:       "ca9e8e502a74b0fe09599e1826761e7285661cbf5e8d5fc75b797c35b920807b"
    sha256 cellar: :any, x86_64_linux:      "1361d9ac9cdc4d2bba59d950032e67568b9b47730aede3c0d3c8365ff56531bd"
  end

  depends_on "python@3.15"

  on_sequoia do
    depends_on xcode: ["16.4", :build] # https://github.com/mit-nlp/MITIE/issues/225
  end

  resource "models-english" do
    url "https://downloads.sourceforge.net/project/mitie/binaries/MITIE-models-v0.2.tar.bz2"
    sha256 "dc073eaef980e65d68d18c7193d94b9b727beb254a0c2978f39918f158d91b31"
  end

  def install
    (share/"MITIE-models").install resource("models-english")

    inreplace "mitielib/makefile", "libmitie.so", "libmitie.dylib" if OS.mac?
    system "make", "mitielib"
    system "make"

    include.install Dir["mitielib/include/*"]
    lib.install "mitielib/#{shared_library("libmitie")}", "mitielib/libmitie.a"

    (prefix/Language::Python.site_packages(python3)).install "mitielib/mitie.py"
    pkgshare.install "examples", "sample_text.txt",
                     "sample_text.reference-output",
                     "sample_text.reference-output-relations"
    bin.install "ner_example", "ner_stream", "relation_extraction_example"
  end

  test do
    system ENV.cc, pkgshare/"examples/C/ner/ner_example.c",
           "-I#{include}", "-L#{lib}", "-lmitie", "-lpthread",
           "-o", testpath/"ner_example"
    system "./ner_example", share/"MITIE-models/english/ner_model.dat",
           pkgshare/"sample_text.txt"
  end
end
