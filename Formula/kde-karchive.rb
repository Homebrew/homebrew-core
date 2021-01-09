class KdeKarchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.78/karchive-5.78.0.tar.xz"
  sha256 "82e7a24280132b1654dc36caba52676b988a9feeaa6dbb9d398b170608f012d3"
  license all_of: [
    "BSD-2-Clause",
    "LGPL-2.0-only",
    "LGPL-2.0-or-later",
    any_of: ["LGPL-2.0-only", "LGPL-3.0-only"],
  ]
  head "https://invent.kde.org/frameworks/karchive.git"

  bottle do
    sha256 "f5cde4cf769c9ade2f09b8e51eed847ee4af926f898b49cb8c533d4b67de59af" => :big_sur
    sha256 "f689fed2d889bec07888ed12409ae9b9805a35aedb1407b5246b672ce5344907" => :arm64_big_sur
    sha256 "e284dad7930966c54df3f93901f55842654ad498a380259b15239fd3e1aa4930" => :catalina
    sha256 "c8f734a6345b440574e9263d8007b7359987e4236258e4fe0e72aa6ec3f55ae6" => :mojave
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "kde-extra-cmake-modules" => [:build, :test]

  depends_on "qt"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DBUILD_QCH=ON"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end

    pkgshare.install "examples"
  end

  test do
    args = std_cmake_args
    args << "-DQt5Core_DIR=#{Formula["qt"].opt_prefix/"lib/cmake/Qt5Core"}"

    %w[bzip2gzip
       helloworld
       tarlocalfiles
       unzipper].each do |test_name|
      mkdir test_name.to_s do
        system "cmake", (pkgshare/"examples/#{test_name}"), *args
        system "make"
      end
    end
  end
end
