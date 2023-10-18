class Mitie < Formula
  desc "Library and tools for information extraction"
  homepage "https://github.com/mit-nlp/MITIE/"
  url "https://github.com/mit-nlp/MITIE/archive/v0.7.tar.gz"
  sha256 "0830955e64c2a4cceab803884355f090cf8e9086e68ac5df43058f05c34697e8"
  license "BSL-1.0"
  revision 3
  head "https://github.com/mit-nlp/MITIE.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "206757071c813ec8b7464f15c897775fc3fa3c30520c2f28f4393139930cafa6"
    sha256 cellar: :any,                 arm64_ventura:  "f12722f2d8be28dccf40dd9a6db1daaafe471274c94d1a1f042f4ee2b44cd2d0"
    sha256 cellar: :any,                 arm64_monterey: "476290231b1f8e2bcef9c6100f7d0855dacfb9fb07d3701d440109ea42f91251"
    sha256 cellar: :any,                 sonoma:         "3d4defc02f23e98c3c21ef64054f1584ca5dfa6ca169c9ec6da679996d9f75c1"
    sha256 cellar: :any,                 ventura:        "85fc39c96b7fff74e52bacd3f586c2c8e7f57d619fdbc5ebfda3391ad196db1c"
    sha256 cellar: :any,                 monterey:       "10455cf05c6209440d4bcd837f6f5b2e89f7ab74030171ae0ce27d60baaf14a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89bc3e10846c5aeef3669467f1aea054fb198772418f428c3dcfcdeb3d95d84a"
  end

  depends_on "python@3.12"

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

    (prefix/Language::Python.site_packages("python3.12")).install "mitielib/mitie.py"
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
