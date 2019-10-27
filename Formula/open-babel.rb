class OpenBabel < Formula
  desc "Chemical toolbox"
  homepage "https://openbabel.org"
  url "https://github.com/openbabel/openbabel/archive/openbabel-3-0-0.tar.gz"
  version "3.0.0"
  sha256 "5c630c4145abae9bb4ab6c56a940985acb6dadf3a8c3a8073d750512c0220f30"
  head "https://github.com/openbabel/openbabel.git"

  bottle do
    sha256 "4ab9e67beff60ffa0f90c8f35b3fc729ecbf44387deca6d42a57feb6b399d6ca" => :catalina
    sha256 "61c3b83067ef6ecff739ad64af1f7dee20c66459838f2584b5ace1077261cbef" => :mojave
    sha256 "0383df12c965d3e2b0087812186992b32ed6d02fc7bcfef397b071db2b96e568" => :high_sierra
    sha256 "fac962fa1127ac9476e5dd1c44ba593c6184bb49444eac28804e45609243e8f9" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rapidjson" => :build
  depends_on "swig" => :build
  depends_on "cairo"
  depends_on "eigen"
  depends_on "python"

  def install
    args = std_cmake_args + %W[
      -DRUN_SWIG=ON
      -DPYTHON_BINDINGS=ON
      -DPYTHON_EXECUTABLE=#{Formula["python"].opt_bin}/python3
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
