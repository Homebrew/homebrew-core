class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.92/karchive-5.92.0.tar.xz"
  sha256 "5076a28c3a10ab755454c752fa563a4be7ad890f391c43aaa2ee4ee4b6a99fae"
  license all_of: [
    "BSD-2-Clause",
    "LGPL-2.0-only",
    "LGPL-2.0-or-later",
    any_of: ["LGPL-2.0-only", "LGPL-3.0-only"],
  ]
  head "https://invent.kde.org/frameworks/karchive.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "956261df7525aed3f18b4ac1419562db70249cca622142390c989d22e384591a"
    sha256 cellar: :any,                 arm64_big_sur:  "e5e215f0519c4e831280e1cb8a5ab35e0df1d22f86ef312b4acb251226a31ea7"
    sha256 cellar: :any,                 monterey:       "55886955636f850df093c19fa9270b3c0f84538f47fba8d767cdc098270c6c8f"
    sha256 cellar: :any,                 big_sur:        "758b5d35149f4da37827faa10fe7730bdaf30ef022e8021e5952e96513db77f4"
    sha256 cellar: :any,                 catalina:       "1c9f44749df8d9f18036fbc7288f6c4cdf137f5a168a9be2904f548221e6606c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86d5a4ca2256c91dffa92acb3333617ce34ab6e9764a4cf396577af80616059f"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build

  depends_on "qt@5"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    args = std_cmake_args + %w[
      -S .
      -B build
      -DBUILD_QCH=ON
    ]

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    ENV.delete "CPATH"
    args = std_cmake_args + %W[
      -DQt5Core_DIR=#{Formula["qt@5"].opt_lib}/cmake/Qt5Core
      -DQT_MAJOR_VERSION=5
    ]

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
