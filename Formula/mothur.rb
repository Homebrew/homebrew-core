class Mothur < Formula
  desc "Analyse microbial ecology data"
  homepage "https://www.mothur.org/"
  url "https://github.com/mothur/mothur/archive/v1.39.5.tar.gz"
  sha256 "9f1cd691e9631a2ab7647b19eb59cd21ea643f29b22cde73d7f343372dfee342"
  head "https://github.com/mothur/mothur.git"

  depends_on "boost"

  # patch related to https://github.com/mothur/mothur/pull/385
  # allow us to do `make install` until next mothur release
  patch do
    url "https://gist.githubusercontent.com/HadrienG/9b275107b86787e474806c7014057870/raw/2d5afe5f4c4b65f8c14de25ecdede8d12a2f793c/gistfile1.txt"
    sha256 "4adc38653c0864f1969303cc34b3d415c1c3feae281d77826fe315c3bd7fa3ed"
  end

  def install
    boost = Formula["boost"]
    system "make", "install", "PREFIX=#{bin}",
      "BOOST_LIBRARY_DIR=#{boost.opt_lib}",
      "BOOST_INCLUDE_DIR=#{boost.opt_include}"
  end

  test do
    (testpath/"fileA").write <<-EOS.undent
    >1
    AGATGTGCTG
    EOS
    (testpath/"fileB").write <<-EOS.undent
    >2
    GCTGAGATGT
    EOS
    (testpath/"test_output").write <<-EOS.undent
    >1
    AGATGTGCTG
    >2
    GCTGAGATGT
    EOS
    system "#{bin}/mothur", "#merge.files(input=fileA-fileB, output=fileAB)"
    assert_predicate testpath/"fileAB", :exist?
    assert_match(File.read("fileAB"), File.read("test_output"))
  end
end
