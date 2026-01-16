class Qjson < Formula
  desc "Map JSON to QVariant objects"
  homepage "https://qjson.sourceforge.net/"
  url "https://github.com/flavio/qjson/archive/refs/tags/0.9.0.tar.gz"
  sha256 "e812617477f3c2bb990561767a4cd8b1d3803a52018d4878da302529552610d4"
  license "LGPL-2.1-only"
  revision 2

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "0e477768711d2b9e0aca6455293f497e860e54455b2eb4fbf7fbfec1ad3754ba"
    sha256 cellar: :any,                 arm64_sequoia:  "d2d3a43592241e2217ea2508fa0ac418058d95d774f5d9fac89cbfe6ec031af0"
    sha256 cellar: :any,                 arm64_sonoma:   "c38d82d6a5e21a82d588066f62825febd4710d2826349ac5bddbe517f22d60a3"
    sha256 cellar: :any,                 arm64_ventura:  "7b927cd12810ef0c8bca41a65c906af9021ef100fcfd1a4686e81607c213fc7e"
    sha256 cellar: :any,                 arm64_monterey: "f9bf3676c0e2b53c3820eb8b9fc6b8a3b3222c86836a925531c4a1ec902bb346"
    sha256 cellar: :any,                 arm64_big_sur:  "073b41a1515c6da30255c50957567eed6f70243aa6845c919fc4d525516fed61"
    sha256 cellar: :any,                 sonoma:         "72a7eb2c9151344e4add590d9107341934efcb6684cfced1a75807d6e57ebbeb"
    sha256 cellar: :any,                 ventura:        "c644e9cc4192087e8cb03fd0c420a8a164354f33453ed4dc15ecde05e475b8c4"
    sha256 cellar: :any,                 monterey:       "49c80dc061c008fb20ebc722596d17845973ee735236be19b8b26cb5293cd043"
    sha256 cellar: :any,                 big_sur:        "282f4fa0cccf91b2f993e6742c295e57016a5a25dc89acd1d5c0f19fdf661734"
    sha256 cellar: :any,                 catalina:       "23138020da1a1d5fc965e242d40ee73838cd233498c1f6aa06fa0146aa895b94"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "beab44351c3cb609985653759a33e712015c6a8689fdaeb70306f90c9225b63d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b64e82e4791c3dc66f6304add6ac44a993b82a9d88d02704af280daa080f5d64"
  end

  # https://github.com/flavio/qjson/commit/6d188cb199a5248889689bd92b757cf0c17cfa27
  deprecate! date: "2025-11-22", because: :repo_archived
  disable! date: "2026-11-22", because: :repo_archived

  depends_on "cmake" => :build
  depends_on "qt@5" # Qt6 issue: https://github.com/flavio/qjson/issues/122

  def install
    # Workaround to build with CMake 4
    args = %w[-DCMAKE_POLICY_VERSION_MINIMUM=3.5]
    inreplace "CMakeLists.txt", "cmake_policy(SET CMP0020 OLD)", ""

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <qjson-qt5/parser.h>
      int main() {
        QJson::Parser parser;
        return 0;
      }
    CPP
    flags = ["-I#{Formula["qt@5"].opt_include}"]
    flags += if OS.mac?
      [
        "-F#{Formula["qt@5"].opt_lib}",
        "-framework", "QtCore"
      ]
    else
      [
        "-fPIC",
        "-L#{Formula["qt@5"].opt_lib}", "-lQt5Core",
        "-Wl,-rpath,#{Formula["qt@5"].opt_lib}",
        "-Wl,-rpath,#{lib}"
      ]
    end
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++11", "-I#{include}",
                    "-L#{lib}", "-lqjson-qt5", *flags
    system "./test"
  end
end
