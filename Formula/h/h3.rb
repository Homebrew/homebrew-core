class H3 < Formula
  desc "Hexagonal hierarchical geospatial indexing system"
  homepage "https://uber.github.io/h3/"
  url "https://github.com/uber/h3/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "438db46fc2b388785d2a0d8e26aa5509739240a7b50b2510c416778d871a4e11"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b02873c2bb46bad3ecb164b0de7010a6cf05e88c24d836be8a623edcd33cb123"
    sha256 cellar: :any,                 arm64_sonoma:  "cdf8ec4cb1d06bd4016315b3c05da5fea167121fdceeae714bc75d63eb780a12"
    sha256 cellar: :any,                 arm64_ventura: "faa658aedc04d5397bcfc3f1c772405c9de7cc586b8ad8d665cb4f0d055ee6e5"
    sha256 cellar: :any,                 sonoma:        "0cfeedcff049140ebefbae1c958833b2a13fbc96a476ac5f5bcef8f01881534f"
    sha256 cellar: :any,                 ventura:       "221c57284d6e1838e6f4deaf5b3090ff628c575a1ec088c5897f90582efd682f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "089248aae3b5dbd2725d56efd962839e3886f4cd0cf99e8f9ac0c05b804ec761"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    result = pipe_output("#{bin}/latLngToCell -r 10 --lat 40.689167 --lng -74.044444")
    assert_equal "8a2a1072b59ffff", result.chomp
  end
end
