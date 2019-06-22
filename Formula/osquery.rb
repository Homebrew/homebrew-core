class Osquery < Formula
  desc "SQL powered operating system instrumentation and analytics"
  homepage "https://osquery.io"
  url "https://github.com/facebook/osquery/archive/3.3.2.tar.gz"
  sha256 "74280181f45046209053a3e15114d93adc80929a91570cc4497931cfb87679e4"
  revision 5

  bottle do
    cellar :any
    sha256 "47f491ca2a096b1f1478672389293ed506b3bd7e08b07ec9d54fc3e697039713" => :mojave
    sha256 "206baf23f17ca77db064c5576e655874055fa00312ec3e87d7e6ccb21c6cae3e" => :high_sierra
    sha256 "27aa7591cff131398915cd954798a4c304a5f327f5af311bb5b63d7ef4ee9445" => :sierra
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "python@2" => :build
  depends_on "augeas"
  depends_on "boost"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "librdkafka"
  depends_on "lldpd"
  # osquery only supports macOS 10.12 and above. Do not remove this.
  depends_on :macos => :sierra
  depends_on "openssl"
  depends_on "rapidjson"
  depends_on "rocksdb"
  depends_on "sleuthkit"
  depends_on "ssdeep"
  depends_on "thrift"
  depends_on "xz"
  depends_on "yara"
  depends_on "zstd"

  fails_with :gcc => "6"

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/c0/41/bae1254e0396c0cc8cf1751cb7d9afc90a602353695af5952530482c963f/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/5f/bd/5815d4d925a2b8cbbb4b4960f018441b0c65f24ba29f3bdcfb3c8218a307/Jinja2-2.8.1.tar.gz"
    sha256 "35341f3a97b46327b3ef1eb624aadea87a535b8f50863036e085e7c426ac5891"
  end

  resource "third-party" do
    url "https://github.com/osquery/third-party/archive/3.0.0.tar.gz"
    sha256 "98731b92147f6c43f679a4a9f63cbb22f2a4d400d94a45e308702dee66a8de9d"
  end

  resource "aws-sdk-cpp" do
    url "https://github.com/aws/aws-sdk-cpp/archive/1.4.55.tar.gz"
    sha256 "0a70c2998d29cc4d8a4db08aac58eb196d404073f6586a136d074730317fe408"
  end

  # Upstream fix for boost 1.69, remove in next version
  # https://github.com/facebook/osquery/pull/5496
  patch do
    url "https://github.com/facebook/osquery/commit/130b3b3324e2.diff?full_index=1"
    sha256 "46bce0c62f1a8f0df506855049991e6fceb6d1cc4e1113a2f657e76b5c5bdd14"
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

    # Skip test and benchmarking.
    ENV["SKIP_TESTS"] = "1"
    ENV["SKIP_DEPS"] = "1"

    # Skip SMART drive tables.
    # SMART requires a dependency that isn't packaged by brew.
    ENV["SKIP_SMART"] = "1"

    # Link dynamically against brew-installed libraries.
    ENV["BUILD_LINK_SHARED"] = "1"
    # Set the version
    ENV["OSQUERY_BUILD_VERSION"] = version

    ENV.prepend_create_path "PYTHONPATH", buildpath/"third-party/python/lib/python2.7/site-packages"

    res = resources.map(&:name).to_set - %w[aws-sdk-cpp third-party]
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
    ]

    args = std_cmake_args + %W[
      -Daws-cpp-sdk-core_library:FILEPATH=#{vendor}/aws-sdk-cpp/lib/libaws-cpp-sdk-core.a
      -Daws-cpp-sdk-firehose_library:FILEPATH=#{vendor}/aws-sdk-cpp/lib/libaws-cpp-sdk-firehose.a
      -Daws-cpp-sdk-kinesis_library:FILEPATH=#{vendor}/aws-sdk-cpp/lib/libaws-cpp-sdk-kinesis.a
      -Daws-cpp-sdk-sts_library:FILEPATH=#{vendor}/aws-sdk-cpp/lib/libaws-cpp-sdk-sts.a
      -DCMAKE_CXX_FLAGS_RELEASE:STRING=#{cxx_flags_release.join(" ")}
    ]

    (buildpath/"third-party").install resource("third-party")

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
