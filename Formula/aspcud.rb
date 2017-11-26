class Aspcud < Formula
  desc "Package dependency solver"
  homepage "https://potassco.org/aspcud/"
  url "https://github.com/potassco/aspcud/archive/v1.9.4.tar.gz"
  sha256 "3645f08b079e1cc80e24cd2d7ae5172a52476d84e3ec5e6a6c0034492a6ea885"
  revision 1

  bottle do
    sha256 "700beffd0ba38265dc95a4b3c344a1974355cb4c20fc50eb7f2d500aaf0ee956" => :high_sierra
    sha256 "73c4df24738a0cea1339241f641657c6e7cb5aecddaba3cb2ecd5e2f6b46fdb5" => :sierra
    sha256 "2658d95252c4d154e3e1aa42fd9762850da1114a8e19c9721c07bb306cbb2955" => :el_capitan
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "re2c" => :build
  depends_on "clingo"

  needs :cxx14

  def install
    args = std_cmake_args
    args << "-DASPCUD_GRINGO_PATH=#{Formula["clingo"].opt_bin}/gringo"
    args << "-DASPCUD_CLASP_PATH=#{Formula["clingo"].opt_bin}/clasp"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"in.cudf").write <<~EOS
      package: foo
      version: 1

      request: foo >= 1
    EOS
    system "#{bin}/aspcud", "in.cudf", "out.cudf"
  end
end
