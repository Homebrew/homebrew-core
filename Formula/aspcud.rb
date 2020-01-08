class Aspcud < Formula
  desc "Package dependency solver"
  homepage "https://potassco.org/aspcud/"
  url "https://github.com/potassco/aspcud/archive/v1.9.4.tar.gz"
  sha256 "3645f08b079e1cc80e24cd2d7ae5172a52476d84e3ec5e6a6c0034492a6ea885"
  revision 1

  bottle do
    sha256 "0196b40592cf41eee37dded4519dbf4fea99df6f1eee4a93922a6dfde7e9eedd" => :catalina
    sha256 "663b82ae45395f7235e1ee0acb7dfc8821efb2a799569c65275ecac90d96570d" => :mojave
    sha256 "07f0e44c6cf608f20da7a37744d7559c1f7b77fc3151bcd37ea0af9fbd39cde7" => :high_sierra
    sha256 "c3c886728b9713da9ec4837b7faf19832219636743654f5b94dbe83b09c83bae" => :sierra
    sha256 "d9f4bb9cd64ba31b4786fc848813cf665ff5f37c761cfb0bacd6c70b50fd9a58" => :el_capitan
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "re2c" => :build
  depends_on "clingo"

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
