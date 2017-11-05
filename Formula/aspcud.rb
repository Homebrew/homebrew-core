class Aspcud < Formula
  desc "Package dependency solver"
  homepage "https://potassco.org/aspcud/"
  url "https://github.com/potassco/aspcud/archive/v1.9.4.tar.gz"
  sha256 "3645f08b079e1cc80e24cd2d7ae5172a52476d84e3ec5e6a6c0034492a6ea885"

  bottle do
    rebuild 2
    sha256 "4444739fb09c808c00fcae057c69b11f3c3d720e252456e19d106bb7e10717fd" => :high_sierra
    sha256 "bc47e294ca6710839f222334031cbb78eb28f6398f6b1266f040f05e7def4349" => :sierra
    sha256 "c57e7a8e2edfd0ae49daa6a02edf5215d26d56756fca3f4e1e2f0848f28fb99d" => :el_capitan
    sha256 "4c8eca79deb4972b2e90222a63cdcab8e84d5dae1dcc02fd700a85a04a66d971" => :yosemite
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "re2c" => :build
  depends_on "gringo"
  depends_on "clasp"

  needs :cxx14

  def install
    args = std_cmake_args
    args << "-DASPCUD_GRINGO_PATH=#{Formula["gringo"].opt_bin}/gringo"
    args << "-DASPCUD_CLASP_PATH=#{Formula["clasp"].opt_bin}/clasp"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    fixture = <<~EOS
      package: foo
      version: 1

      request: foo >= 1
    EOS

    (testpath/"in.cudf").write(fixture)
    system "#{bin}/aspcud", "in.cudf", "out.cudf"
  end
end
