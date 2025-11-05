class Iccdev < Formula
  desc "Demonstration Implementation for iccMAX color profiles"
  homepage "https://github.com/InternationalColorConsortium/iccDEV"
  url "https://github.com/InternationalColorConsortium/iccDEV/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "8795b52a400f18a5192ac6ab3cdeebc11dd7c1809288cb60bb7339fec6e7c515"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a0fa7ef2c3fff4ae1471d847c7b2c66262a37e1b05cdb76dee43d8cbfd3b25a3"
    sha256 cellar: :any,                 arm64_sequoia: "99f69a6b54cfcb704ef21587efe44807de2a9a59cdd246e810cab227eed13836"
    sha256 cellar: :any,                 arm64_sonoma:  "9110e467dbfdfa76ac123ed2b55b705fc393e840ae43f3ea21a846b1fd1ecea8"
    sha256 cellar: :any,                 sonoma:        "0f4e7e69eeaed19ada693b7faeab0ed1d6e46dffee791173f6faae92cdd3f8c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42623e444cc3f58fa5d91460b5f9a927c5769df0eb3a65d0e298571d2033dc20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0797679df4466b5faad4f6a5669fec5a7d91241e24892bb9a864b574a08c3763"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "wxwidgets"

  uses_from_macos "libxml2"

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DENABLE_TOOLS=ON
      -DENABLE_SHARED_LIBS=ON
      -DENABLE_INSTALL_RIM=ON
      -DENABLE_ICCXML=ON
    ]

    system "cmake", "-S", "Build/Cmake", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "Testing/Calc/CameraModel.xml"
  end

  test do
    system bin/"iccFromXml", pkgshare/"CameraModel.xml", "output.icc"
    assert_path_exists testpath/"output.icc"

    system bin/"iccToXml", "output.icc", "output.xml"
    assert_path_exists testpath/"output.xml"
  end
end
