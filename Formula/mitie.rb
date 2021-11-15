class Mitie < Formula
  desc "Library and tools for information extraction"
  homepage "https://github.com/mit-nlp/MITIE/"
  url "https://github.com/mit-nlp/MITIE/archive/v0.7.tar.gz"
  sha256 "0830955e64c2a4cceab803884355f090cf8e9086e68ac5df43058f05c34697e8"
  license "BSL-1.0"
  revision 3
  head "https://github.com/mit-nlp/MITIE.git"

  bottle do
    sha256 cellar: :any, arm64_monterey: "85090e5f3a58d0e1b4d809bb67813684bce137134f9d903dfeae192e4540ffe8"
    sha256 cellar: :any, arm64_big_sur:  "ad562a270ddfb8ffc19c35fd3ec680a1152f3fc25d0bfa9d07f32ba49f563086"
    sha256 cellar: :any, monterey:       "508dd4609e72647b3534466576df9e18a0717c9387cf68c9bbf14f3d8769f5f8"
    sha256 cellar: :any, big_sur:        "1a3f80b1b4c26c82cd9b0110d244ffa40aa30933a8b92ecfc1a6bf1e1265480a"
    sha256 cellar: :any, catalina:       "edf72d45db9f8b0772e21dd024b9f44a2ff40b926ae2c1662e394b9468c19863"
    sha256 cellar: :any, mojave:         "4bf2422b5d421784cc2829fd5987132c89a82637c7d05a3a34b95568084c8457"
  end

  depends_on "python@3.10"

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
