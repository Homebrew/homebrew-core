class Kdoctools < Formula
  desc "Create documentation from DocBook"
  homepage "https://api.kde.org/frameworks/kdoctools/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.88/kdoctools-5.88.0.tar.xz"
  sha256 "14b00acc8129395cb7e523a7cb55ec6ddb479166c96693b7b13eefe285ec9030"
  license all_of: [
    "BSD-3-Clause",
    "GPL-2.0-or-later",
    "LGPL-2.1-or-later",
    any_of: ["LGPL-2.1-only", "LGPL-3.0-only"],
  ]
  head "https://invent.kde.org/frameworks/kdoctools.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "54c61a6d3b93a46afe90ad30cb83f1ff168e2e4beddd89615c75c61058995b89"
    sha256 cellar: :any, big_sur:       "c5d4b159c576f074cd4896e0e03808f5d28f37b7a61e7214171c89b1b3dff2ad"
    sha256 cellar: :any, catalina:      "c0cf3a6b1e5b33394a6873c7e83a7ddae5c386614e2df94166c9f70f03b0757f"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "docbook-xsl" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "gettext" => :build
  depends_on "ki18n" => :build

  depends_on "karchive"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "perl"

  resource "URI::Escape" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.09.tar.gz"
    sha256 "03e63ada499d2645c435a57551f041f3943970492baa3b3338246dab6f1fae0a"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV.prepend_path "PERL5LIB", libexec/"lib"

    resource("URI::Escape").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make", "install"
    end

    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DBUILD_QCH=ON"

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install ["cmake", "autotests", "tests"]
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.5)
      include(FeatureSummary)
      find_package(ECM 5.71.0 NO_MODULE)
      set_package_properties(ECM PROPERTIES TYPE REQUIRED)
      set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} "#{pkgshare}/cmake")
      find_package(Qt5 5.12.0 REQUIRED Core)
      find_package(KF5DocTools REQUIRED)

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
    EOS

    cp_r (pkgshare/"autotests"), testpath
    cp_r (pkgshare/"tests"), testpath

    args = std_cmake_args
    args << "-DQt5_DIR=#{Formula["qt@5"].opt_prefix/"lib/cmake/Qt5"}"

    system "cmake", testpath.to_s, *args
    system "make"
  end
end
