class Mitie < Formula
  desc "Library and tools for information extraction"
  homepage "https://github.com/mit-nlp/MITIE/"
  url "https://github.com/mit-nlp/MITIE/archive/v0.7.tar.gz"
  sha256 "0830955e64c2a4cceab803884355f090cf8e9086e68ac5df43058f05c34697e8"
  license "BSL-1.0"
  revision 3
  head "https://github.com/mit-nlp/MITIE.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "7f07defbed3d51ba5924ac8899ca02c37f1f91b596a96d6fdb61a6aa7e016f44"
    sha256 cellar: :any,                 arm64_monterey: "8ffdc33a97a73185b528c95ba47ea4598164e5acc96260d32fab5b3eaae63676"
    sha256 cellar: :any,                 arm64_big_sur:  "78981478637045457fa8b6ba9f22333d40485ce8e2055bbf1a1b9f87878d7780"
    sha256 cellar: :any,                 ventura:        "4e0aa20259afddb380bde9ef00978b17a61207042ec17062015939f69f4890b3"
    sha256 cellar: :any,                 monterey:       "3d5d6c140f6efb9eb6dbbd0c92c8faaf47d239d58679c9256b71a35c4f8dfc1e"
    sha256 cellar: :any,                 big_sur:        "b9df7253ad6fa374ddcbb0b03dd402b85dc09720191c308800d50c7a1bcafea2"
    sha256 cellar: :any,                 catalina:       "26373657c4989ff1fe0eda638afe51372bf8aea82e5189d15c82454340a771cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f17f2b6c0bb5f1733bbcda7225bbe7fe113b7818e5ef8ac900297a3f7708a194"
  end

  depends_on "python@3.11"

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

    (prefix/Language::Python.site_packages("python3.11")).install "mitielib/mitie.py"
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
