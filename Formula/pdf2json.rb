class Pdf2json < Formula
  desc "PDF to JSON and XML converter"
  homepage "https://github.com/flexpaper/pdf2json"
  url "https://github.com/flexpaper/pdf2json/archive/0.70.tar.gz"
  sha256 "65d7c273c3dc003470ee61a429274b3612a0ee995e75dc32ad8dbdc9d03fbad1"

  bottle do
    cellar :any_skip_relocation
    sha256 "ffcee90aedfc094b2339da1ea20d13533944e3cb504c83bf14c5a35e3c8fc6d3" => :catalina
    sha256 "43e67dfa77c38eb32a4ae1b079c565752e567598596d8adaaa7d4f464eee7696" => :mojave
    sha256 "82d6e789d9a698b1eca23ed91ef3ecc3a67db1faa4a1f530f2f1452484d8ca8b" => :high_sierra
  end

  def install
    system "./configure"
    system "make", "CC=#{ENV.cc}", "CXX=#{ENV.cxx}"
    bin.install "src/pdf2json"
  end

  test do
    system bin/"pdf2json", test_fixtures("test.pdf"), "test.json"
    assert_predicate testpath/"test.json", :exist?
  end
end
