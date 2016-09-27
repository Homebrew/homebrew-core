class Arangodb < Formula
  desc "The Multi-Model NoSQL Database."
  homepage "https://www.arangodb.com/"
  url "https://www.arangodb.com/repositories/Source/ArangoDB-3.0.5.tar.gz"
  sha256 "c9219c9dc5cc35a0e2dfab8420f9fd0cdd7143669f0776a08907164a20e03a4e"
  head "https://github.com/arangodb/arangodb.git", :branch => "unstable"

  bottle do
    sha256 "232c55b3277b217d26cb429a0afe3d709cdcf1ab23cfd77496fc71ecda40040f" => :sierra
    sha256 "e8fa7b1e5c7bf3d9d18b830c8ed9e365c4d0fc5704a2732f208b5113a4d3b5ca" => :el_capitan
    sha256 "1ca08be2a4f88515e2f2ee765703a963a0c9df44a50d5cc9f4787ce0822f27e7" => :yosemite
  end

  depends_on :macos => :yosemite
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
        -DCMAKE_INSTALL_DATADIR=#{share}
        -DETCDIR=#{etc}
        -DVARDIR=#{var}
      ]

      if ENV.compiler == "gcc-6"
        ENV.append "V8_CXXFLAGS", "-O3 -g -fno-delete-null-pointer-checks"
      end

      system "cmake", "..", *args
      system "make", "install"

      %w[arangod arango-dfdb arangosh foxx-manager].each do |f|
        inreplace etc/"arangodb3/#{f}.conf", pkgshare, opt_pkgshare
      end
    end
  end

  def post_install
    oldpath_prefix = "#{HOMEBREW_PREFIX}/Cellar/arangodb/3.0."
    oldpath_regexp = /#{Regexp.escape(oldpath_prefix)}[12]/

    %w[arangod arango-dfdb arangosh foxx-manager].each do |f|
      inreplace etc/"arangodb3/#{f}.conf", oldpath_regexp, opt_prefix, false
    end

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
