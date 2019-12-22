class Cnpy < Formula
  desc "C++ io of numpy"
  homepage "https://github.com/rogersce/cnpy"
#  url "https://github.com/rogersce/cnpy/archive/master.tar.gz"
  url "https://github.com/cxwx/cnpy/archive/V0.1.0.tar.gz"
#  version "0.1.0"


  depends_on "cmake" => [:build, :test]

  def install
    mkdir "corsika-build" do
      args = std_cmake_args + %w[
        ../
        -DCMAKE_BUILD_TYPE=Release
      ]

      system "cmake", *args
      system "make", "install"
    end
  end

end
