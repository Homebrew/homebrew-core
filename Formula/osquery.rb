class Osquery < Formula
  desc "SQL powered operating system instrumentation and analytics"
  homepage "https://osquery.io"
  # pull from git tag to get submodules
  url "https://github.com/facebook/osquery.git",
    :tag => "1.7.3",
    :revision => "6901aa644a9bcc0667207008db71471abf756b82"
  revision 7

  bottle do
    cellar :any
    sha256 "95754d664079c26612212c9938d866ca89d91db1005f7983379caa13844b8387" => :sierra
    sha256 "ed195dad4d45ea120df0b7fdd578693b0f519ff336713259e000101eaa4925c9" => :el_capitan
    sha256 "9279afff7830b7cf05dd8b741f1e06800cfb37761e13ad62d370493a39680467" => :yosemite
  end

  fails_with :gcc => "6"

  # osquery only supports OS X 10.9 and above. Do not remove this.
  depends_on :macos => :mavericks

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "rocksdb"
  depends_on "thrift"
  depends_on "yara"
  depends_on "openssl"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libmagic"
  depends_on "lz4"
  depends_on "cpp-netlib"
  depends_on "sleuthkit"

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/c0/41/bae1254e0396c0cc8cf1751cb7d9afc90a602353695af5952530482c963f/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/5f/bd/5815d4d925a2b8cbbb4b4960f018441b0c65f24ba29f3bdcfb3c8218a307/Jinja2-2.8.1.tar.gz"
    sha256 "35341f3a97b46327b3ef1eb624aadea87a535b8f50863036e085e7c426ac5891"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/d9/c8/8c7a2ab8ec108ba9ab9a4762c5a0d67c283d41b13b5ce46be81fdcae3656/psutil-5.0.1.tar.gz"
    sha256 "9d8b7f8353a2b2eb6eb7271d42ec99d0d264a9338a37be46424d56b4e473b39e"
  end

  # as of gflags 2.2.0 FlagRegisterer no longer needs type specified
  # reported 26 Nov 2016 https://github.com/facebook/osquery/issues/2798
  # upstream PR from 26 Nov 2016 https://github.com/facebook/osquery/pull/2800
  # original gflags PR https://github.com/gflags/gflags/pull/158
  # breaking commit https://github.com/gflags/gflags/commit/46ea10f
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/dc800df/osquery/patch-gflags-2.2.0.diff"
    sha256 "be111edf7d46b7a0c630e73ce754c00ff2c289b5221b87080b9e7eb57ec1e4b0"
  end

  resource "boost" do
    url "https://downloads.sourceforge.net/project/boost/boost/1.62.0/boost_1_62_0.tar.bz2"
    sha256 "36c96b0f6155c98404091d8ceb48319a28279ca0333fba1ad8611eb90afb2ca0"
  end

  def install
    ENV.cxx11

    resource("boost").stage do
      # Force boost to compile with the desired compiler
      open("user-config.jam", "a") do |file|
        file.write "using darwin : : #{ENV.cxx} ;\n"
        file.write "using mpi ;\n" if build.with? "mpi"
      end

      bootstrap_args = %W[
        --without-icu
        --prefix=#{libexec}/boost
        --libdir=#{libexec}/boost/lib
        --with-libraries=filesystem,regex,system
      ]

      args = %W[
        --prefix=#{libexec}/boost
        --libdir=#{libexec}/boost/lib
        -d2
        -j#{ENV.make_jobs}
        --ignore-site-config
        --layout=tagged
        --user-config=user-config.jam
        install
        threading=multi
        link=static
        optimization=space
        variant=release
        cxxflags=-std=c++11
      ]

      if ENV.compiler == :clang
        args << "cxxflags=-stdlib=libc++" << "linkflags=-stdlib=libc++"
      end

      system "./bootstrap.sh", *bootstrap_args
      system "./b2", "headers"
      system "./b2", *args
    end

    # Skip test and benchmarking.
    ENV["SKIP_TESTS"] = "1"

    ENV.prepend_create_path "PYTHONPATH", buildpath/"third-party/python/lib/python2.7/site-packages"
    ENV["THRIFT_HOME"] = Formula["thrift"].opt_prefix

    res = resources.map(&:name).to_set - ["boost"]
    res.each do |r|
      resource(r).stage do
        system "python", "setup.py", "install",
                                 "--prefix=#{buildpath}/third-party/python/",
                                 "--single-version-externally-managed",
                                 "--record=installed.txt"
      end
    end

    ENV["BOOST_ROOT"] = Formula["osquery"].libexec/"boost/include"

    args = std_cmake_args + %W[
      -Dboost_filesystem_library:FILEPATH=#{libexec}/boost/lib/libboost_filesystem-mt.a
      -Dboost_regex_library:FILEPATH=#{libexec}/boost/lib/libboost_regex-mt.a
      -Dboost_system_library:FILEPATH=#{libexec}/boost/lib/libboost_system-mt.a
    ]

    # Link dynamically against brew-installed libraries.
    ENV["BUILD_LINK_SHARED"] = "1"

    system "cmake", ".", *args
    system "make"
    system "make", "install"
  end

  plist_options :startup => true, :manual => "osqueryd"

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <osquery/sdk.h>

      using namespace osquery;

      class ExampleTablePlugin : public TablePlugin {
       private:
        TableColumns columns() const {
          return {{"example_text", TEXT_TYPE}, {"example_integer", INTEGER_TYPE}};
        }

        QueryData generate(QueryContext& request) {
          QueryData results;
          Row r;

          r["example_text"] = "example";
          r["example_integer"] = INTEGER(1);
          results.push_back(r);
          return results;
        }
      };

      REGISTER_EXTERNAL(ExampleTablePlugin, "table", "example");

      int main(int argc, char* argv[]) {
        Initializer runner(argc, argv, OSQUERY_EXTENSION);
        runner.shutdown();
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-o", "test", "-v", "-std=c++11",
                    "-I#{include}", "-I#{libexec}/boost/include",
                    "-I#{Formula["gflags"].opt_include}",
                    "-I#{Formula["glog"].opt_include}",
                    "-L#{lib}", "-L#{libexec}/boost/lib",
                    "-L#{Formula["gflags"].opt_lib}",
                    "-L#{Formula["glog"].opt_lib}",
                    "-L#{Formula["rocksdb"].opt_lib}",
                    "-L#{Formula["thrift"].opt_lib}",
                    "-losquery", "-lboost_filesystem-mt", "-lboost_system-mt",
                    "-lgflags", "-lglog", "-lrocksdb", "-lthrift"
    system "./test"
  end
end
