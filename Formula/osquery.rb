class Osquery < Formula
  desc "SQL powered operating system instrumentation and analytics"
  homepage "https://osquery.io"
  # pull from git tag to get submodules
  url "https://github.com/facebook/osquery.git",
      :tag => "2.11.1",
      :revision => "489ec3fc59d8cedc45cbc6392b7ff1c9f2f79903"
  revision 1
  head "https://github.com/facebook/osquery.git"

  bottle do
    cellar :any
    sha256 "425d10624a6af2c4552ad09cf49f161218cd6bcc0c34ab19978f674f3469bc7f" => :high_sierra
    sha256 "30b38692f84fc7c4bde1209eb9beff85ecd94999a3d4cddba2cd4e46267133e1" => :sierra
  end

  fails_with :gcc => "6"

  # osquery only supports macOS 10.12 and above. Do not remove this.
  depends_on :macos => :sierra
  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "asio"
  depends_on "augeas"
  depends_on "boost"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "lldpd"
  depends_on "librdkafka"
  depends_on "openssl"
  depends_on "rapidjson"
  depends_on "rocksdb"
  depends_on "sleuthkit"
  depends_on "thrift"
  depends_on "yara"
  depends_on "xz"
  depends_on "zstd"

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

  resource "aws-sdk-cpp" do
    url "https://github.com/aws/aws-sdk-cpp/archive/1.2.7.tar.gz"
    sha256 "1f65e63dbbceb1e8ffb19851a8e0ee153e05bf63bfa12b0e259d50021ac3ab6e"
  end

  resource "cpp-netlib" do
    url "https://github.com/cpp-netlib/cpp-netlib/archive/cpp-netlib-0.12.0-final.tar.gz"
    sha256 "d66e264240bf607d51b8d0e743a1fa9d592d96183d27e2abdaf68b0a87e64560"
  end

  resource "linenoise" do
    url "https://github.com/theopolis/linenoise-ng/archive/v1.0.1.tar.gz"
    sha256 "c317f3ec92dcb4244cb62f6fb3b7a0a5a53729a85842225fcfce0d4a429a0dfa"
  end

  def install
    ENV.cxx11

    vendor = buildpath/"brew_vendor"

    resource("aws-sdk-cpp").stage do
      args = std_cmake_args + %W[
        -DSTATIC_LINKING=1
        -DNO_HTTP_CLIENT=1
        -DMINIMIZE_SIZE=ON
        -DBUILD_SHARED_LIBS=OFF
        -DBUILD_ONLY=ec2;firehose;kinesis;sts
        -DCMAKE_INSTALL_PREFIX=#{vendor}/aws-sdk-cpp
      ]

      mkdir "build" do
        system "cmake", "..", *args
        system "make"
        system "make", "install"
      end
    end

    resource("cpp-netlib").stage do
      args = std_cmake_args + %W[
        -DCMAKE_INSTALL_PREFIX=#{vendor}/cpp-netlib
        -DCPP-NETLIB_BUILD_TESTS=OFF
        -DCPP-NETLIB_BUILD_EXAMPLES=OFF
      ]
      system "cmake", ".", *args
      system "make"
      system "make", "install"
    end

    resource("linenoise").stage do
      mkdir "build" do
        args = std_cmake_args + %W[
          -DCMAKE_INSTALL_PREFIX=#{vendor}/linenoise
          -DCMAKE_CXX_FLAGS=-mno-avx\ -fPIC
        ]
        system "cmake", "..", *args
        system "make"
        system "make", "install"
      end
    end

    # Skip test and benchmarking.
    ENV["SKIP_TESTS"] = "1"

    ENV.prepend_create_path "PYTHONPATH", buildpath/"third-party/python/lib/python2.7/site-packages"

    res = resources.map(&:name).to_set - %w[aws-sdk-cpp cpp-netlib linenoise]
    res.each do |r|
      resource(r).stage do
        system "python", "setup.py", "install",
                                 "--prefix=#{buildpath}/third-party/python/",
                                 "--single-version-externally-managed",
                                 "--record=installed.txt"
      end
    end

    cxx_flags_release = %W[
      -DNDEBUG
      -I#{MacOS.sdk_path}/usr/include/libxml2
      -I#{vendor}/aws-sdk-cpp/include
      -I#{vendor}/cpp-netlib/include
      -I#{vendor}/linenoise/include
      -Wl,-L#{vendor}/linenoise/lib
    ]

    args = std_cmake_args + %W[
      -Daws-cpp-sdk-core_library:FILEPATH=#{vendor}/aws-sdk-cpp/lib/libaws-cpp-sdk-core.a
      -Daws-cpp-sdk-firehose_library:FILEPATH=#{vendor}/aws-sdk-cpp/lib/libaws-cpp-sdk-firehose.a
      -Daws-cpp-sdk-kinesis_library:FILEPATH=#{vendor}/aws-sdk-cpp/lib/libaws-cpp-sdk-kinesis.a
      -Daws-cpp-sdk-sts_library:FILEPATH=#{vendor}/aws-sdk-cpp/lib/libaws-cpp-sdk-sts.a
      -Dcppnetlib-client-connections_library:FILEPATH=#{vendor}/cpp-netlib/lib/libcppnetlib-client-connections.a
      -Dcppnetlib-uri_library:FILEPATH=#{vendor}/cpp-netlib/lib/libcppnetlib-uri.a
      -Dlinenoise_library:FILEPATH=#{vendor}/linenoise/lib/liblinenoise.a
      -DCMAKE_CXX_FLAGS_RELEASE:STRING=#{cxx_flags_release.join(" ")}
    ]

    # Link dynamically against brew-installed libraries.
    ENV["BUILD_LINK_SHARED"] = "1"

    system "cmake", ".", *args
    system "make"
    system "make", "install"
    (include/"osquery/core").install Dir["osquery/core/*.h"]
  end

  plist_options :startup => true, :manual => "osqueryd"

  test do
    assert_match "platform_info", shell_output("#{bin}/osqueryi -L")
  end
end
