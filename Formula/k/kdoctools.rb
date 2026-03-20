class Kdoctools < Formula
  desc "Create documentation from DocBook"
  homepage "https://l10n.kde.org/docs/doc-primer/"
  url "https://download.kde.org/stable/frameworks/6.24/kdoctools-6.24.0.tar.xz"
  sha256 "aee351c52f783813c6c114ade520c8578c570ee6dc25ecbd64c83e3d2d9660d4"
  license all_of: [
    "BSD-3-Clause",
    "GPL-2.0-or-later",
    "LGPL-2.1-or-later",
    any_of: ["LGPL-2.1-only", "LGPL-3.0-only"],
  ]
  head "https://invent.kde.org/frameworks/kdoctools.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6c70ea8cfecdfd7c9869c5fbd23b5044e8b6468945a15ed2249dc3edc083ffa4"
    sha256 cellar: :any,                 arm64_sequoia: "1aeb61eafc698af88f6e2dadb62a8f22bf251f90e7ea8b8ed15ad68acfe3450f"
    sha256 cellar: :any,                 arm64_sonoma:  "f933a07263bfe44337d62cc6517ccefab0ffd308e96cd5f097b2f1ea7425320e"
    sha256 cellar: :any,                 sonoma:        "0663872f16d67d9b4d72384c87fee5759bbac812fb801b306225353d3b37b11d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b3168bd0af6d7f0131074dddd8a4513374443b19931cb8d38360152d9d4b2a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "400e2c4234e46c491d129e59ae414c7688242156a821d82cead1ac3c3db3f1ba"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "gettext" => :build
  depends_on "ki18n" => :build
  depends_on "qttools" => :build
  depends_on "docbook-xsl"
  depends_on "karchive"
  depends_on "qtbase"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "perl"

  resource "URI::Escape" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.34.tar.gz"
      sha256 "de64c779a212ff1821896c5ca2bb69e74767d2674cee411e777deea7a22604a8"
    end
  end

  def install
    if OS.linux?
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
      ENV.prepend_path "PERL5LIB", libexec/"lib"

      resource("URI::Escape").stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    system "cmake", "-S", ".", "-B", "build", "-DBUILD_QCH=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install ["cmake", "autotests", "tests"]
  end

  test do
    qt = Formula["qtbase"]
    qt_major = qt.version.major

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      include(FeatureSummary)
      find_package(ECM #{version} NO_MODULE)
      set_package_properties(ECM PROPERTIES TYPE REQUIRED)
      set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} "#{pkgshare}/cmake")
      find_package(Qt#{qt_major} #{qt.version} REQUIRED Core)
      find_package(KF#{qt_major}DocTools REQUIRED)

      find_package(LibXslt)
      set_package_properties(LibXslt PROPERTIES TYPE REQUIRED)

      find_package(LibXml2)
      set_package_properties(LibXml2 PROPERTIES TYPE REQUIRED)

      if (NOT LIBXML2_XMLLINT_EXECUTABLE)
         message(FATAL_ERROR "xmllint is required to process DocBook XML")
      endif()

      find_package(DocBookXML4 "4.5")
      set_package_properties(DocBookXML4 PROPERTIES TYPE REQUIRED)

      find_package(DocBookXSL)
      set_package_properties(DocBookXSL PROPERTIES TYPE REQUIRED)

      remove_definitions(-DQT_NO_CAST_FROM_ASCII)
      add_definitions(-DQT_NO_FOREACH)

      add_subdirectory(autotests)
      add_subdirectory(tests/create-from-current-dir-test)
      add_subdirectory(tests/kdoctools_install-test)
    CMAKE

    cp_r (pkgshare/"autotests"), testpath
    cp_r (pkgshare/"tests"), testpath

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
  end
end
