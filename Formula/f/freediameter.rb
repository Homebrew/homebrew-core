class Freediameter < Formula
  desc "Open source Diameter (Authentication) protocol implementation"
  homepage "https://github.com/freeDiameter/freeDiameter"
  license "BSD-3-Clause"
  head "https://github.com/freeDiameter/freeDiameter.git", branch: "master"

  stable do
    url "https://github.com/freeDiameter/freeDiameter/archive/refs/tags/1.5.0.tar.gz"
    sha256 "cc4ceafd9d0d4a6a5e3aa02bf557906fe755df9ec14d16c4fcd5dab6930296aa"

    # Backport support for `libidn2`. Remove in the next release.
    patch do
      url "https://github.com/freeDiameter/freeDiameter/commit/da679d27c546e11f6e41ad8882699f726e58a9f7.patch?full_index=1"
      sha256 "123fe68ede4713b8e78efa49bfe9db592291cc3c821bbdc58f930a1f291423b1"
    end

    # Bump minimum required cmake version to 3.10. Remove in the next release.
    # Backport of: https://github.com/freeDiameter/freeDiameter/commit/45106adf3bf4192b274ef6c5536200a0e19c84f2
    patch :DATA
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256                               arm64_tahoe:   "5eafa2b1cff32588e446f38812e5d28bdbbdc3efca9c5d04d3d8c75aadc63c1a"
    sha256                               arm64_sequoia: "3a0fdc3ba68de137c1c7565a2bf1952cf239c35717276e185ef2c57d8f042a0f"
    sha256                               arm64_sonoma:  "77cce28c5fae584b97aefe1d124bf14da292e5f40f62a4bfccb4b545feecf9f8"
    sha256                               arm64_ventura: "a0a2bb922fe5286a90703eaf346ab465702d3bb43040b11f4c49f2b4296ec768"
    sha256                               sonoma:        "40a30f89b5587df10f03275e37b9d17c4ca3a59098f2efddf5e521b9a71276b6"
    sha256                               ventura:       "3b25d64d36dabbcdd24ca3d2c02bf05f8bff8ddcdb764f58d01c3fed25a50e57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f092135225eda295f1bd57f85b49c8b4cdcdf9241878b0d7c9971f28eb5a570"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "224a65066b5831f9a7c9d07c2f4439075fe60f8e287c3a4e19fbfc163124e5b7"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "libidn2"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DDEFAULT_CONF_PATH=#{etc}
      -DDISABLE_SCTP=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    doc.install Dir["doc/*"]
    pkgshare.install "contrib"
  end

  def post_install
    return if File.exist?(etc/"freeDiameter.conf")

    cp doc/"freediameter.conf.sample", etc/"freeDiameter.conf"
  end

  def caveats
    <<~EOS
      To configure freeDiameter, edit #{etc}/freeDiameter.conf to taste.

      Sample configuration files can be found in #{doc}.

      For more information about freeDiameter configuration options, read:
        http://www.freediameter.net/trac/wiki/Configuration

      Other potentially useful files can be found in #{opt_pkgshare}/contrib.
    EOS
  end

  service do
    run opt_bin/"freeDiameterd"
    keep_alive true
    require_root true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/freeDiameterd --version")
  end
end

__END__
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -1,5 +1,8 @@
 # This file is the source for generating the Makefile for the project, using cmake tool (cmake.org)

+# CMake version
+CMAKE_MINIMUM_REQUIRED(VERSION 3.10)
+
 # Name of the project
 PROJECT("freeDiameter")

@@ -19,9 +22,6 @@ SET(FD_PROJECT_VERSION_API 6)
 # The test framework, using CTest and CDash.
 INCLUDE(CTest)

-# CMake version
-CMAKE_MINIMUM_REQUIRED(VERSION 2.6)
-
 # Location of additional CMake modules
 SET(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/Modules/")

--- a/libfdcore/CMakeLists.txt
+++ b/libfdcore/CMakeLists.txt
@@ -2,10 +2,7 @@
 Project("freeDiameter core library" C)

 # Configuration for newer cmake
-cmake_policy(VERSION 2.6)
-if (POLICY CMP0022)
-	cmake_policy(SET CMP0022 OLD)
-endif (POLICY CMP0022)
+cmake_policy(VERSION 3.10)

 # Configuration parser
 BISON_FILE(fdd.y)
--- a/libfdproto/CMakeLists.txt
+++ b/libfdproto/CMakeLists.txt
@@ -2,10 +2,7 @@
 Project("libfdproto" C)

 # Configuration for newer cmake
-cmake_policy(VERSION 2.6)
-if (POLICY CMP0022)
-	cmake_policy(SET CMP0022 OLD)
-endif (POLICY CMP0022)
+cmake_policy(VERSION 3.10)

 # List of source files for the library
 SET(LFDPROTO_SRC
