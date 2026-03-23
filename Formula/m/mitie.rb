class Mitie < Formula
  desc "Library and tools for information extraction"
  homepage "https://github.com/mit-nlp/MITIE/"
  url "https://github.com/mit-nlp/MITIE/archive/refs/tags/v0.7.tar.gz"
  sha256 "0830955e64c2a4cceab803884355f090cf8e9086e68ac5df43058f05c34697e8"
  license "BSL-1.0"
  revision 3
  head "https://github.com/mit-nlp/MITIE.git", branch: "master"

  bottle do
    rebuild 4
    sha256 cellar: :any,                 arm64_tahoe:   "025cb3eb83b916c6311a5282c51ba1c44d9890dcb158b4b8327e5ae0deda4a8b"
    sha256 cellar: :any,                 arm64_sequoia: "9aa9238fdd29d5a705c3e342f883e147424c62329bc9cdb81ef939079c7d67f3"
    sha256 cellar: :any,                 arm64_sonoma:  "876af22594ab08bfb316893df9fd16f8e761c42502bafde4eaf82fd188a3f420"
    sha256 cellar: :any,                 sonoma:        "71792924c5aca7fe2d3db9db416c89552b95690ecf236e681cbe2d1e846ba72e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9999c37c7d297991dd328c5868a1eea42dc26a193e5725d9a766e2c11852394"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "906519532491d62f21e16e31ef3fccb49672ca033bf811cf289f93bcb6468eeb"
  end

  depends_on "python@3.14"

  on_sequoia do
    depends_on xcode: ["15.3", :build]
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

    (prefix/Language::Python.site_packages("python3.14")).install "mitielib/mitie.py"
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
