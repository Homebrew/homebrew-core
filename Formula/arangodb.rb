class Arangodb < Formula
  desc "The Multi-Model NoSQL Database."
  homepage "https://www.arangodb.com/"
  url "https://www.arangodb.com/repositories/Source/ArangoDB-3.0.2.tar.gz"
  sha256 "04c00d58d7e63137ccb7d0a73112aa01e34e08c98b3c82c62ef7987f0d214ac2"
  head "https://github.com/arangodb/arangodb.git", :branch => "unstable"

  bottle do
    sha256 "358382598b83897515c32c3182b24fea99842d721d626ccef9cf169a8dbb1639" => :el_capitan
    sha256 "db166984be2d166206ee348b3d6741093b8bec5b45ac9f456cbb300d4d6c0e02" => :yosemite
    sha256 "57139fadef3855ef14bed71c2f9c5f37a2f991f35163cf6b810020fa0e077d13" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on "openssl"

  needs :cxx11

  fails_with :clang do
    build 600
    cause "Fails with compile errors"
  end

  resource "arangodb2" do
    url "https://www.arangodb.com/repositories/Source/ArangoDB-2.8.10.tar.gz"
    sha256 "3a455e9d6093739660ad79bd3369652db79f3dabd9ae02faca1b014c9aa220f4"
  end

  resource "upgrade" do
    url "https://www.arangodb.com/repositories/Source/upgrade3-1.0.0.tar.gz"
    sha256 "965f899685e420530bb3c68ada903c815ebd0aa55e477d6949abba9506574011"
  end

  def install
    ENV.cxx11

    (libexec/"arangodb2/bin").install resource("upgrade")

    resource("arangodb2").stage do
      ENV.cxx11

      args = %W[
        --disable-dependency-tracking
        --prefix=#{libexec}/arangodb2
        --disable-relative
        --localstatedir=#{var}
        --program-suffix=-2.8
      ]

      if ENV.compiler == "gcc-6"
        ENV.append "CXXFLAGS", "-O2 -g -fno-delete-null-pointer-checks"
        inreplace "3rdParty/Makefile.v8", "CXXFLAGS=\"", "CXXFLAGS=\"-fno-delete-null-pointer-checks "
      end

      system "./configure", *args
      system "make", "install"
    end

    mkdir "build" do
      args = std_cmake_args + %W[
        -DHOMEBREW=ON
        -DUSE_OPTIMIZE_FOR_ARCHITECTURE=OFF
        -DASM_OPTIMIZATIONS=OFF
        -DETCDIR=#{etc}
        -DVARDIR=#{var}
      ]

      if ENV.compiler == "gcc-6"
        ENV.append "V8_CXXFLAGS", "-O3 -g -fno-delete-null-pointer-checks"
      end

      system "cmake", "..", *args
      system "make", "V=1", "Verbose=1", "VERBOSE=1", "install"
    end
  end

  def post_install
    (var/"lib/arangodb3").mkpath
    (var/"log/arangodb3").mkpath

    args = %W[
      #{libexec}/arangodb2
      #{var}/lib/arangodb
      #{opt_prefix}
      #{var}/lib/arangodb3
    ]

    system libexec/"arangodb2/bin/upgrade.sh", *args
  end

  def caveats
    s = <<-EOS.undent
      The database format between ArangoDB 2.x and ArangoDB 3.x has
      been changed, please checkout
      https://docs.arangodb.com/3.0/Manual/Administration/Upgrading/index.html

      An empty password has been set. Please change it by executing
        #{opt_sbin}/arango-secure-installation
    EOS

    s
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/arangodb/sbin/arangod"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>Program</key>
        <string>#{opt_sbin}/arangod</string>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end

  test do
    testcase = "require('@arangodb').print('it works!')"
    output = shell_output("#{bin}/arangosh --server.password \"\" --javascript.execute-string \"#{testcase}\"")
    assert_equal "it works!", output.chomp
  end
end
