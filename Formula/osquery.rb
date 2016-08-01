class Osquery < Formula
  desc "SQL powered operating system instrumentation and analytics"
  homepage "https://osquery.io"
  # pull from git tag to get submodules
  url "https://github.com/facebook/osquery.git",
    :tag => "1.7.4",
    :revision => "209900d5a87fd5111ca99bb1cc201f3ad357222e"

  bottle do
    cellar :any
    revision 2
    sha256 "9680d2abb0779b5f5e46cc2c78ab001647a2d1c4baa3de221f7c64e310c89d70" => :el_capitan
    sha256 "81a6604250d13a57b0bcb49712a41cfb9e44610ee40a6247e009c6e8bcc1af23" => :yosemite
    sha256 "52d59b00eafe102cb008c6c426c0575bc78145ff3191e0b1cdf11a422c070736" => :mavericks
  end

  # osquery only supports OS X 10.9 and above. Do not remove this.
  depends_on :macos => :mavericks

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "rocksdb"
  depends_on "thrift"
  depends_on "yara"
  depends_on "libressl"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libmagic"
  depends_on "cpp-netlib"
  depends_on "sleuthkit"

  resource "markupsafe" do
    url "https://pypi.python.org/packages/c0/41/bae1254e0396c0cc8cf1751cb7d9afc90a602353695af5952530482c963f/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "jinja2" do
    url "https://pypi.python.org/packages/f2/2f/0b98b06a345a761bec91a079ccae392d282690c2d8272e708f4d10829e22/Jinja2-2.8.tar.gz"
    sha256 "bc1ff2ff88dbfacefde4ddde471d1417d3b304e8df103a7a9437d47269201bf4"
  end

  resource "argparse" do
    url "https://pypi.python.org/packages/18/dd/e617cfc3f6210ae183374cd9f6a26b20514bbb5a792af97949c5aacddf0f/argparse-1.4.0.tar.gz"
    sha256 "62b089a55be1d8949cd2bc7e0df0bddb9e028faefc8c32038cc84862aefdd6e4"
  end

  def install
    # Link dynamically against brew-installed libraries.
    ENV["BUILD_LINK_SHARED"] = "1"

    # Use LibreSSL instead of the system provided OpenSSL.
    ENV["BUILD_USE_LIBRESSL"] = "1"

    # Skip test and benchmarking.
    ENV["SKIP_TESTS"] = "1"

    ENV.prepend_create_path "PYTHONPATH", buildpath/"third-party/python/lib/python2.7/site-packages"
    ENV["THRIFT_HOME"] = Formula["thrift"].opt_prefix

    resources.each do |r|
      r.stage do
        system "python", "setup.py", "install",
                                 "--prefix=#{buildpath}/third-party/python/",
                                 "--single-version-externally-managed",
                                 "--record=installed.txt"
      end
    end

    system "cmake", ".", *std_cmake_args
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
      "-losquery", "-lthrift", "-lboost_system", "-lboost_thread-mt",
      "-lboost_filesystem", "-lglog", "-lgflags", "-lrocksdb"
    system "./test"
  end
end
