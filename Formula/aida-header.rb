class AidaHeader < Formula
  desc "Abstract Interfaces for Data Analysis define interfaces for physics analysis"
  homepage "https://aida.freehep.org/index.thtml"
  url "ftp://ftp.slac.stanford.edu/software/freehep/AIDA/v3.2.1/aida-3.2.1-src.tar.gz"
  sha256 "882d351bc09e830ae2eb512a2cbf44af5a82ef8efe31fbe0d047363da8314c81"
  license "LGPL-3.0-or-later"

  def install
    include.install "src/cpp/AIDA"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <AIDA/AIDA.h>

      int main() {
        std::cout<<"AIDA version "<<AIDA_VERSION<<std::endl;
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-I#{include}"
    assert_match "AIDA version 3.2.1", shell_output("./a.out")
  end
end
