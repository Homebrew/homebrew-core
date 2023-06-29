class Kdoctools < Formula
  desc "Create documentation from DocBook"
  homepage "https://api.kde.org/frameworks/kdoctools/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.107/kdoctools-5.107.0.tar.xz"
  sha256 "9d56a0493f5fe10e7419ff97be56e4afbbc011eb19c379a42f5a58a860711550"
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
    sha256 cellar: :any,                 arm64_ventura:  "48249dc5dceff8e676dd59b5e6fc5f365f76b9f415a5926308bdf67445f5ca58"
    sha256 cellar: :any,                 arm64_monterey: "0c03ae2ceb318e6a8e984f4f6ae3616eb628c3a8c52890dedeee5f948a5b7eed"
    sha256 cellar: :any,                 arm64_big_sur:  "4367702a365e72759dc93edb3e8d75347e615873b1a5b17f119c4f5204141851"
    sha256 cellar: :any,                 ventura:        "8fae00fb7c7a5b0e1eda9630d223949835089167b4c9b87fd1375ef85ca070a3"
    sha256 cellar: :any,                 monterey:       "6d5dec746d81c09486b0e1aa41bb01fa41faf82e5510eff27ef388a044b2d889"
    sha256 cellar: :any,                 big_sur:        "c689430b1a4c81067b0676bcc0b1d3b4fe2cea2e03a2100562df503897e6aa13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b0da02cb0df4fd553af96f31fa9108c1df56f258341bdb8976536df904218eb"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "gettext" => :build
  depends_on "ki18n" => :build

  depends_on "docbook-xsl"
  depends_on "karchive"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "perl"

  fails_with gcc: "5"

  resource "URI::Escape" do
    url "https://cpan.metacpan.org/authors/id/O/OA/OALDERS/URI-5.12.tar.gz"
    sha256 "66abe0eaddd76b74801ecd28ec1411605887550fc0a45ef6aa744fdad768d9b3"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV.prepend_path "PERL5LIB", libexec/"lib"

    resource("URI::Escape").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make", "install"
    end

    args = std_cmake_args + %w[
      -S .
      -B build
      -DBUILD_QCH=ON
    ]

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install ["cmake", "autotests", "tests"]
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.5)
      include(FeatureSummary)
      find_package(ECM #{version} NO_MODULE)
      set_package_properties(ECM PROPERTIES TYPE REQUIRED)
      set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} "#{pkgshare}/cmake")
      find_package(Qt5 #{Formula["qt@5"].version} REQUIRED Core)
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

    args = std_cmake_args + %W[
      -S .
      -B build
      -DQt5_DIR=#{Formula["qt@5"].opt_lib}/cmake/Qt5
    ]

    system "cmake", *args
    system "cmake", "--build", "build"
  end
end
