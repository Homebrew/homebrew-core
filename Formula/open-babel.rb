class OpenBabel < Formula
  desc "Chemical toolbox"
  homepage "https://openbabel.org"
  url "https://github.com/openbabel/openbabel/archive/openbabel-3-1-1.tar.gz"
  version "3.1.1"
  sha256 "c97023ac6300d26176c97d4ef39957f06e68848d64f1a04b0b284ccff2744f02"
  license "GPL-2.0"
  revision 1
  head "https://github.com/openbabel/openbabel.git"

  bottle do
    sha256 "770cdafc4dfdd0c216ca9308d5b5ae6b9b00be8d30b387dd2e86cbff82db5acd" => :catalina
    sha256 "6c44b3e574a786396b8099192e5154f1d751ee413ec265c99f8046fc5167876a" => :mojave
    sha256 "49d5dc2fc8c9a857bf08e6e6711fbaf48d8a0165c328cc400e904aa5a37080a4" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rapidjson" => :build
  depends_on "swig" => :build
  depends_on "cairo"
  depends_on "eigen"
  depends_on "python@3.9"

  def install
    args = std_cmake_args + %W[
      -DRUN_SWIG=ON
      -DPYTHON_BINDINGS=ON
      -DPYTHON_EXECUTABLE=#{Formula["python@3.9"].opt_bin}/python3
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
