class JsonSpirit < Formula
  desc "C++ JSON parser/generator"
  homepage "https://www.codeproject.com/Articles/20027/JSON-Spirit-A-C-JSON-Parser-Generator-Implemented"
  url "https://github.com/png85/json_spirit/archive/json_spirit-4.0.8.tar.gz"
  # Current release is misnamed on GitHub, previous versioning scheme and homepage
  # dictate the release as "4.08".
  version "4.08"
  sha256 "43829f55755f725c06dd75d626d9e57d0ce68c2f0d5112fe9a01562c0501e94c"

  bottle do
    cellar :any
    sha256 "83e0551760113ed4c6a23db7670c64b19f59b841d9ec8dd76cf5bdc833c66088" => :mojave
    sha256 "0eed2985cea7cc97f61f595591b52889884e47617a3cebe8b0f78da0f26de95a" => :high_sierra
    sha256 "4c7c56c29cb1e6b2f866004a82aeb89e66f177a5b155c6d723338957c0ad228f" => :sierra
    sha256 "7668e993b4d8ca4493d6e8a706378e840b35409a96b1ac928fd96c8933528cf4" => :el_capitan
    sha256 "192b4f814c55d038a5a0d8ab1dd13698d1f4daa4899ef9ce1cb22b8562442a96" => :yosemite
    sha256 "fba55377ce6098174e392e66df972e070f58f9a259aa38cad592eaf2e808eace" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    args = std_cmake_args
    args << "-DBUILD_STATIC_LIBRARIES=ON"

    system "cmake", *args
    system "make"

    args = std_cmake_args
    args << "-DBUILD_STATIC_LIBRARIES=OFF"
    system "cmake", *args
    system "make", "install"
  end
end
