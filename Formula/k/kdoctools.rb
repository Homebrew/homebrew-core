class Kdoctools < Formula
  desc "Create documentation from DocBook"
  homepage "https://l10n.kde.org/docs/doc-primer/"
  url "https://download.kde.org/stable/frameworks/6.28/kdoctools-6.28.0.tar.xz"
  sha256 "024914031fba7a9b79982d02736b21399d9a0d09ad81323d58e17d6b2216c7b0"
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
    sha256 cellar: :any, arm64_tahoe:   "0af7a2ae8c6f410b58c882e44179935e2d3d99cfff5d53b1e07b85aa54a634ff"
    sha256 cellar: :any, arm64_sequoia: "176a30c78eb1d6d6d346c95793a0ea2b0f03bf358eebc3154c438f5f50e8330d"
    sha256 cellar: :any, arm64_sonoma:  "bce446be3edb04514afa8bd7c9c3660fc28942ca9066e684cd7132ca6e1dbeb0"
    sha256 cellar: :any, sonoma:        "009457f1419f13726fa48af59acac7ca173e8c49c119e81cf0857878b0ca6394"
    sha256 cellar: :any, arm64_linux:   "357e5bee0cb5e67e3d90385c3d23d1127e5606376feb8e962f718b1c7a21ea00"
    sha256 cellar: :any, x86_64_linux:  "a040e6c29687ca3338cd87a4b01ca37285891b3e0f29e5239d46789773068449"
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

  uses_from_macos "perl" => :build
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "URI::Escape" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.34.tar.gz"
      sha256 "de64c779a212ff1821896c5ca2bb69e74767d2674cee411e777deea7a22604a8"
    end
  end

  def install
    if OS.linux?
      ENV.prepend_create_path "PERL5LIB", buildpath/"lib/perl5"

      resource("URI::Escape").stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{buildpath}"
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
