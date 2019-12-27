class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "https://frei0r.dyne.org/"
  url "https://files.dyne.org/frei0r/releases/frei0r-plugins-1.7.0.tar.gz"
  sha256 "1b1ff8f0f9bc23eed724e94e9a7c1d8f0244bfe33424bb4fe68e6460c088523a"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b1cd892e6e980a0bc6547d62d6be821fe16dd8910876ef3b415b909b41a5ab66" => :catalina
    sha256 "a509ee11dc4a3cd431a888c708d32c53d81e5ca67250520f91284d4370d946d4" => :mojave
    sha256 "7bef9c45d808de6bf3f7026ff0c96e4ddadd2ca3a5f8737ce9041f7aa828e6a1" => :high_sierra
    sha256 "28d07c64bce38e3fa9c76437ce86b86ae34ac317070f1e167dbbc1f825f68b46" => :sierra
  end

  depends_on "cmake" => :build

  def install
    # Disable opportunistic linking against Cairo
    inreplace "CMakeLists.txt", "find_package (Cairo)", ""
    cmake_args = std_cmake_args + %w[
      -DWITHOUT_OPENCV=ON
      -DWITHOUT_GAVL=ON
    ]
    system "cmake", ".", *cmake_args
    system "make", "install"
  end
end
