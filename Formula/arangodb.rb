class Arangodb < Formula
  desc "Multi-Model NoSQL Database"
  homepage "https://www.arangodb.com/"
  url "https://download.arangodb.com/Source/ArangoDB-3.7.2-1.tar.gz"
  sha256 "de79c04b6b15d9b7a415f8cbfd6682e000414725be1c25966aeab19dfbb49195"
  license "Apache-2.0"
  revision 1
  head "https://github.com/arangodb/arangodb.git", branch: "devel"

  bottle do
    sha256 "f66b2c46e2c8201e8e7a9ff32b5bf22cebe948d6d5dc1cedb1cc09f9dae72bd2" => :catalina
    sha256 "4c6b0c1ecf14fdb837c52b3205ce98c820768b57a50526e51cb93133d95123ef" => :mojave
  end

  depends_on "ccache" => :build
  depends_on "cmake" => :build
  depends_on "go@1.13" => :build
  depends_on "python@3.9" => :build
  depends_on macos: :mojave
  depends_on "openssl@1.1"

  # the ArangoStarter is in a separate github repository;
  # it is used to easily start single server and clusters
  # with a unified CLI
  resource "starter" do
    url "https://github.com/arangodb-helper/arangodb.git",
      tag:      "0.14.15",
      revision: "e32307e9ae5a0046214cb066355a8577e6fc4148"
  end

  def install
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    resource("starter").stage do
      ENV["GO111MODULE"] = "on"
      ENV["DOCKERCLI"] = ""
      # use commit-id as projectBuild
      commit = `git rev-parse HEAD`.chomp
      system "make", "deps"
      ldflags = %W[
        -s -w
        -X main.projectVersion=#{resource("starter").version}
        -X main.projectBuild=#{commit}
      ]
      system "go", "build", *std_go_args, "-ldflags", ldflags.join(" "), "github.com/arangodb-helper/arangodb"
    end

    mkdir "build" do
      openssl = Formula["openssl@1.1"]
      args = std_cmake_args + %W[
        -DHOMEBREW=ON
        -DCMAKE_BUILD_TYPE=RelWithDebInfo
        -DUSE_MAINTAINER_MODE=Off
        -DUSE_JEMALLOC=Off
        -DCMAKE_SKIP_RPATH=On
        -DOPENSSL_USE_STATIC_LIBS=On
        -DCMAKE_LIBRARY_PATH=#{openssl.opt_lib}
        -DOPENSSL_ROOT_DIR=#{openssl.opt_lib}
        -DCMAKE_OSX_DEPLOYMENT_TARGET=#{MacOS.version}
        -DTARGET_ARCHITECTURE=nehalem
        -DUSE_CATCH_TESTS=Off
        -DUSE_GOOGLE_TESTS=Off
        -DCMAKE_INSTALL_LOCALSTATEDIR=#{var}
      ]

      ENV["V8_CXXFLAGS"] = "-O3 -g -fno-delete-null-pointer-checks" if ENV.compiler == "gcc-6"

      system "cmake", "..", *args
      system "make", "install"
    end
  end

  def post_install
    (var/"lib/arangodb3").mkpath
    (var/"log/arangodb3").mkpath
  end

  def caveats
    <<~EOS
      An empty password has been set. Please change it by executing
        #{opt_sbin}/arango-secure-installation
    EOS
  end

  plist_options manual: "#{HOMEBREW_PREFIX}/opt/arangodb/sbin/arangod"

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
