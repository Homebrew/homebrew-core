class OpenBabel < Formula
  desc "Chemical toolbox"
  homepage "https://openbabel.org"
  url "https://github.com/openbabel/openbabel/archive/openbabel-3-0-0.tar.gz"
  version "3.0.0"
  sha256 "5c630c4145abae9bb4ab6c56a940985acb6dadf3a8c3a8073d750512c0220f30"
  revision 1
  head "https://github.com/openbabel/openbabel.git"

  bottle do
    sha256 "6ec66d0aaa1e1e16bd551a6a2f9e147a207770f800ff15938a6c9547299bb4c9" => :catalina
    sha256 "a3c4902398ed67b093d5f88b03872a0fa07eba615a6d51fc998644d09f748486" => :mojave
    sha256 "f3c05baedaa87da66362fb942d248973728e1336277f885b6aa513e7a8c20b53" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rapidjson" => :build
  depends_on "swig" => :build
  depends_on "cairo"
  depends_on "eigen"
  depends_on "python@3.8"

  def install
    args = std_cmake_args + %W[
      -DRUN_SWIG=ON
      -DPYTHON_BINDINGS=ON
      -DPYTHON_EXECUTABLE=#{Formula["python@3.8"].opt_bin}/python3
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/obabel", "-:'C1=CC=CC=C1Br'", "-omol"
  end
end
