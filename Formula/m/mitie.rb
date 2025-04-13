class Mitie < Formula
  desc "Library and tools for information extraction"
  homepage "https://github.com/mit-nlp/MITIE/"
  url "https://github.com/mit-nlp/MITIE/archive/refs/tags/v0.7.tar.gz"
  sha256 "0830955e64c2a4cceab803884355f090cf8e9086e68ac5df43058f05c34697e8"
  license "BSL-1.0"
  revision 3
  head "https://github.com/mit-nlp/MITIE.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_sequoia: "7b817e7140c3a2cc2b13d2a53b4d7a759396626fe2cb6394c8605fdcf3ab3b0c"
    sha256 cellar: :any,                 arm64_sonoma:  "1ea2d1a30cb6131307d2eaf4a7f7f42a5ceb0fccbac2dc957a94813e53de0ef8"
    sha256 cellar: :any,                 arm64_ventura: "726cd7ce7124c79eef06e62131063703acfebc44a94a60ac4fca02964f2eebb2"
    sha256 cellar: :any,                 sonoma:        "db00e58505d015d5b25ca8e1e07988dffcf570e991ab857b420e733fb2aeac7e"
    sha256 cellar: :any,                 ventura:       "52e0e6cdce288f3608a9b96f76912fcb9c196c2120f2c81f4e7fe16ff1a8098d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15d673bf303a022cb9ce16b0840104f5eb6f1c4e9afb594600de42d02f0772cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae4cfbe0ce3984b155dd82c76fb0434f23ede413e5adbd7927819c2c9f22717a"
  end

  depends_on "python@3.13"

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

    (prefix/Language::Python.site_packages("python3.13")).install "mitielib/mitie.py"
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
