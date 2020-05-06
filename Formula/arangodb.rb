class Arangodb < Formula
  desc "The Multi-Model NoSQL Database"
  homepage "https://www.arangodb.com/"
  url "https://download.arangodb.com/Source/ArangoDB-3.6.3-1.tar.gz"
  sha256 "434a4ec6670008927a48c9a247d344639d0355feb4f58c1aa60397ca5d2711c2"
  head "https://github.com/arangodb/arangodb.git", :branch => "devel"

  bottle do
    sha256 "e84209b460ddc4a8dc868d8f5ceba7d4ce478ebba51a5c204b149baa9495ec0f" => :catalina
    sha256 "14c64c8339f728ce34b8671daad6f8d94b13fd0cda6f6875c37cfe48ad7f9b2a" => :mojave
  end

  depends_on "ccache" => :build
  depends_on "cmake" => :build
  depends_on "go@1.13" => :build
  depends_on :macos => :mojave
  depends_on "openssl@1.1"

  # the ArangoStarter is in a separate github repository;
  # it is used to easily start single server and clusters
  # with a unified CLI
  resource "starter" do
    url "https://github.com/arangodb-helper/arangodb.git",
      :revision => "598e7d7794ad4a98024548dd9061e03782542ecd"
  end

  def install
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    resource("starter").stage do
      ENV.append "GOPATH", Dir.pwd + "/.gobuild"
      ENV.append "DOCKERCLI", ""
      system "make", "deps"
      # use commit-id as projectBuild
      commit = `git rev-parse HEAD`.chomp
      system "go", "build", "-ldflags", "-X main.projectVersion=0.14.14 -X main.projectBuild=#{commit}",
                            "-o", "arangodb",
                            "github.com/arangodb-helper/arangodb"
      bin.install "arangodb"
    end

    mkdir "build" do
      args = std_cmake_args + %W[
        -DHOMEBREW=ON
        -DCMAKE_BUILD_TYPE=RelWithDebInfo
        -DUSE_MAINTAINER_MODE=Off
        -DUSE_JEMALLOC=Off
        -DCMAKE_SKIP_RPATH=On
        -DOPENSSL_USE_STATIC_LIBS=On
        -DCMAKE_LIBRARY_PATH=#{prefix}/opt/openssl@1.1/lib
        -DOPENSSL_ROOT_DIR=#{prefix}/opt/openssl@1.1/lib
        -DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}
        -DTARGET_ARCHITECTURE=nehalem
        -DUSE_CATCH_TESTS=Off
        -DUSE_GOOGLE_TESTS=Off
        -DCMAKE_INSTALL_LOCALSTATEDIR=#{var}
      ]

      ENV.append "V8_CXXFLAGS", "-O3 -g -fno-delete-null-pointer-checks" if ENV.compiler == "gcc-6"

      system "cmake", "..", *args
      system "make", "install"
    end
  end

  def post_install
    (var/"lib/arangodb3").mkpath
    (var/"log/arangodb3").mkpath
  end

  def caveats
    s = <<~EOS
      An empty password has been set. Please change it by executing
        #{opt_sbin}/arango-secure-installation
    EOS

    s
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/arangodb/sbin/arangod"

  def plist
    <<~EOS
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
    require "pty"

    testcase = "require('@arangodb').print('it works!')"
    output = shell_output("#{bin}/arangosh --server.password \"\" --javascript.execute-string \"#{testcase}\"")
    assert_equal "it works!", output.chomp

    ohai "#{bin}/arangodb --starter.instance-up-timeout 1m --starter.mode single"
    PTY.spawn("#{bin}/arangodb", "--starter.instance-up-timeout", "1m",
              "--starter.mode", "single", "--starter.disable-ipv6",
              "--server.arangod", "#{sbin}/arangod",
              "--server.js-dir", "#{share}/arangodb3/js") do |r, _, pid|
      loop do
        available = IO.select([r], [], [], 60)
        assert_not_equal available, nil

        line = r.readline.strip
        ohai line

        break if line.include?("Your single server can now be accessed")
      end
    ensure
      Process.kill "SIGINT", pid
      ohai "shuting down #{pid}"
    end
  end
end
