class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.85/karchive-5.85.0.tar.xz"
  sha256 "8c196e9195485622c7e5f4523584e1e7551827a0bfbe477d08d34b7847ab6b2f"
  license all_of: [
    "BSD-2-Clause",
    "LGPL-2.0-only",
    "LGPL-2.0-or-later",
    any_of: ["LGPL-2.0-only", "LGPL-3.0-only"],
  ]
  head "https://invent.kde.org/frameworks/karchive.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "4603b87ebd5e4e3fba10c28e31be00ff89a8134aea1361b7f4cefb63f6860f23"
    sha256 cellar: :any, big_sur:       "39f92e2091f0d15d7c2d778d99ce2b25155487cc5921c10f89ba82a1bb15a20e"
    sha256 cellar: :any, catalina:      "d4fe94de78ae2f140b2fa97739a42ca1f4ad8edc5953f05501cb05940c0e962b"
    sha256 cellar: :any, mojave:        "bc17b1ba460d4cd541a207844d328104dceb370c198bb2df4b0ac21cee0e5527"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build

  depends_on "qt@5"
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
    ENV.delete "CPATH"
    args = std_cmake_args
    args << "-DQt5Core_DIR=#{Formula["qt@5"].opt_prefix/"lib/cmake/Qt5Core"}"

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
