class AidaHeader < Formula
  desc "Abstract Interfaces for Data Analysis define interfaces for physics analysis"
  homepage "https://aida.freehep.org/"
  url "ftp://ftp.slac.stanford.edu/software/freehep/AIDA/v3.2.1/aida-3.2.1-src.tar.gz"
  sha256 "882d351bc09e830ae2eb512a2cbf44af5a82ef8efe31fbe0d047363da8314c81"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://aida.freehep.org/download.thtml"
    regex(%r{href=.*?/AIDA/v?(\d+(?:\.\d+)+)/}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dbbfb4a01fb14b65b959fe8666c25d894a3b0b0a6e2badb14346c8ba71673bf2"
    sha256 cellar: :any_skip_relocation, big_sur:       "eba4b33299b9ed8ed988c4c17fbffe1e17364a7d284878247c3b0a738fe2b340"
    sha256 cellar: :any_skip_relocation, catalina:      "50a1e944d768d3f6b5d8dcaf8d074d821272056104369e85f72539c628b770f2"
    sha256 cellar: :any_skip_relocation, mojave:        "d4559d46451c98728a32679f6d62b7ee4c9a5fa57c18e7ba9315e33d2e7150b8"
  end

  deprecate! date: "2022-03-30", because: :unmaintained

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
