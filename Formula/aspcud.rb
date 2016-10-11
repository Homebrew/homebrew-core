class Aspcud < Formula
  desc "Package dependency solver"
  homepage "http://potassco.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/potassco/aspcud/1.9.1/aspcud-1.9.1-source.tar.gz"
  sha256 "e0e917a9a6c5ff080a411ff25d1174e0d4118bb6759c3fe976e2e3cca15e5827"

  bottle do
    rebuild 2
    sha256 "bc47e294ca6710839f222334031cbb78eb28f6398f6b1266f040f05e7def4349" => :sierra
    sha256 "c57e7a8e2edfd0ae49daa6a02edf5215d26d56756fca3f4e1e2f0848f28fb99d" => :el_capitan
    sha256 "4c8eca79deb4972b2e90222a63cdcab8e84d5dae1dcc02fd700a85a04a66d971" => :yosemite
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "re2c" => :build
  depends_on "gringo"
  depends_on "clasp"

  def install
    args = std_cmake_args
    args << "-DGRINGO_LOC=#{Formula["gringo"].opt_bin}/gringo"
    args << "-DCLASP_LOC=#{Formula["clasp"].opt_bin}/clasp"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    fixture = <<-EOS.undent
      package: foo
      version: 1

      request: foo >= 1
    EOS

    (testpath/"in.cudf").write(fixture)
    system "#{bin}/aspcud", "in.cudf", "out.cudf"
  end
end
