class Kdoctools < Formula
  desc "Create documentation from DocBook"
  homepage "https://api.kde.org/frameworks/kdoctools/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.95/kdoctools-5.95.0.tar.xz"
  sha256 "6f56d0f31bf7965331d2f3a6f4c1880d7ae4ab3d16424338a2906207e9c63a82"
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
    sha256 cellar: :any,                 arm64_monterey: "88844927b953560ed1013342b5a8667238d39262d2493b854ed2feaae27ff2cb"
    sha256 cellar: :any,                 arm64_big_sur:  "91ea6d194395374575acb6a652d621b33663c5379b79ac9ed0c52115d119f983"
    sha256 cellar: :any,                 monterey:       "d8fad28c707dbe20beab3b16efd7115595f73b30ca428de024a27f3c2662d2ba"
    sha256 cellar: :any,                 big_sur:        "4977b7dd3112c5ca4932e06370824c85af63ca8c89040c9b887189416e896625"
    sha256 cellar: :any,                 catalina:       "c2cb5c0d5839d518cd03483ac3bd9c06c82efc69477afcc1f069fb7b803f3229"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a34d063e95afb1ecd261e9bf50948f9ee9f3dc4454151c41dae705da9d3a3cd"
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

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

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
