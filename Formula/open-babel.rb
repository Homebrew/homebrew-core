class OpenBabel < Formula
  desc "Chemical toolbox"
  homepage "https://openbabel.org"
  url "https://github.com/openbabel/openbabel/archive/openbabel-3-1-1.tar.gz"
  version "3.1.1"
  sha256 "c97023ac6300d26176c97d4ef39957f06e68848d64f1a04b0b284ccff2744f02"
  head "https://github.com/openbabel/openbabel.git"

  bottle do
    sha256 "997886c087d6c342ea47649bb6de0e50fa807a2116aaad2119490b8921b85edf" => :catalina
    sha256 "d8bf12ee10f070e6ca4396fa37d02da80f5449f5c3927a0050ffbb028331a01a" => :mojave
    sha256 "035d300440fbfaaf20939137db63e8f78246983a16db563dcd1b66f4980685f4" => :high_sierra
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
