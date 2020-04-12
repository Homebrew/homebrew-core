class Osquery < Formula
  desc "SQL powered operating system instrumentation and analytics"
  homepage "https://osquery.io"
  url "https://github.com/facebook/osquery/archive/4.2.0.tar.gz"
  sha256 "8b1710bf9c2bfb6febd45b077164da58a6db6865a63c43c382364f6713f67545"

  bottle do
    cellar :any
    sha256 "a8237ae1f35816b66cef87950432547a033fb4b04b7429117d60d1cb7fce8bfc" => :catalina
    sha256 "9b12fe9d5a0ba261cf4927f0ab467b960228922b0b06757b40a9c4f5636d2007" => :mojave
    sha256 "6173a4e452c925a7dcba0d09ef54c174caf9f416e04eb2fb2705681bd267e9d5" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "ccache" => :build
  depends_on "cmake" => :build
  depends_on "python" => :build
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
  depends_on "openssl@1.1"
  depends_on "rapidjson"
  depends_on "rocksdb"
  depends_on "sleuthkit"
  depends_on "ssdeep"
  depends_on "thrift"
  depends_on "xz"
  depends_on "yara"
  depends_on "zstd"

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/b9/2e/64db92e53b86efccfaea71321f597fa2e1b2bd3853d8ce658568f7a13094/MarkupSafe-1.1.1.tar.gz"
    sha256 "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/d8/03/e491f423379ea14bb3a02a5238507f7d446de639b623187bccc111fbecdf/Jinja2-2.11.1.tar.gz"
    sha256 "93187ffbc7808079673ef52771baa950426fd664d3aad1d0fa3e95644360e250"
  end

  resource "third-party" do
    url "https://github.com/osquery/third-party/archive/3.0.0.tar.gz"
    sha256 "98731b92147f6c43f679a4a9f63cbb22f2a4d400d94a45e308702dee66a8de9d"
  end

  resource "aws-sdk-cpp" do
    url "https://github.com/aws/aws-sdk-cpp/archive/1.4.55.tar.gz"
    sha256 "0a70c2998d29cc4d8a4db08aac58eb196d404073f6586a136d074730317fe408"
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

    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", buildpath/"third-party/python/lib/python#{xy}/site-packages"

    res = resources.map(&:name).to_set - %w[aws-sdk-cpp third-party]
    res.each do |r|
      resource(r).stage do
        system "python3", "setup.py", "install",
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
