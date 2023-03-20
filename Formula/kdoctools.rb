class Kdoctools < Formula
  desc "Create documentation from DocBook"
  homepage "https://api.kde.org/frameworks/kdoctools/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.104/kdoctools-5.104.0.tar.xz"
  sha256 "115b4ed2bc8c58355a53e3bfaa9abe51713fa0ca49dedc1e5ebb8c50bf1b44dc"
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
    sha256 cellar: :any,                 arm64_ventura:  "ed8b6a4179d3043b2cf8eb2aa7444d5f9badfb258fdd0be43ab6ae9c4557f748"
    sha256 cellar: :any,                 arm64_monterey: "df65f32f163c8a01dd265d80da74ccd93d65843a9209a089b670dd86e0de71e5"
    sha256 cellar: :any,                 arm64_big_sur:  "70ff7210f2c5cad28cf751822983f80082c3fc167ca818a907003b0bd89ff26b"
    sha256 cellar: :any,                 ventura:        "d9e048392c72b0067d3be48d26cf33d9ce87d5bc8e5a2f3fadfaaae9303057b1"
    sha256 cellar: :any,                 monterey:       "0e323bb20c9681f32e22889d932a33e52c28067fd5d215e1607b7a3e795aec34"
    sha256 cellar: :any,                 big_sur:        "e5404627d41a5cdf72c210a7efec6db971defd7992cb57509ac94bbe15988015"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1ca551e326ef0c0e104acb39ffe9683a85beaaff1343e6b392a28228da973a0"
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
