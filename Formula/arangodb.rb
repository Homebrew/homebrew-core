class Arangodb < Formula
  desc "The Multi-Model NoSQL Database"
  homepage "https://www.arangodb.com/"
  url "https://download.arangodb.com/Source/ArangoDB-3.5.1.tar.gz"
  sha256 "4e648c0aff129a02dd0279303880603cd92dd27b81ef7c40dee3eded9102c1cb"
  head "https://github.com/arangodb/arangodb.git", :branch => "devel"

  bottle do
    sha256 "c5f3e3fbe5d695597bf20a95e8c2ffdb6e8b74bee6ef3fd7989555ac8f9d718b" => :mojave
    sha256 "e8053c9157efe620fe7d2660993ac7f929a9a914e2a5bc758f52d5c80de9fe84" => :high_sierra
    sha256 "431fb46ca96833c6c097b3e132a3210afb8bc954d2106a823099731733bcc220" => :sierra
  end

  depends_on "ccache" => :build
  depends_on "cmake" => :build
  depends_on "go" => :build
  depends_on :macos => :mojave
  depends_on "openssl@1.1"

  # see https://gcc.gnu.org/bugzilla/show_bug.cgi?id=87665
  fails_with :gcc => "7"

  # the ArangoStarter is in a separate github repository;
  # it is used to easily start single server and clusters
  # with a unified CLI
  resource "starter" do
    url "https://github.com/arangodb-helper/arangodb.git",
      :revision => "bbe29730e70dba609b57c469e8f863f032fabf3e"
  end

  # fixed upstream in https://github.com/arangodb/arangodb/commit/55ca6c8660e0b373bae1840d61894a4202913cfa
  patch :DATA

  def install
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    resource("starter").stage do
      ENV.append "GOPATH", Dir.pwd + "/.gobuild"
      system "make", "deps"
      # use commit-id as projectBuild
      commit = `git rev-parse HEAD`.chomp
      system "go", "build", "-ldflags", "-X main.projectVersion=0.14.12 -X main.projectBuild=#{commit}",
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

      if ENV.compiler == "gcc-6"
        ENV.append "V8_CXXFLAGS", "-O3 -g -fno-delete-null-pointer-checks"
      end

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

  def plist; <<~EOS
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
      begin
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
end

__END__
diff --git a/arangod/Graph/BreadthFirstEnumerator.h b/arangod/Graph/BreadthFirstEnumerator.h
index 40fcf76472..66f50e9877 100644
--- a/arangod/Graph/BreadthFirstEnumerator.h
+++ b/arangod/Graph/BreadthFirstEnumerator.h
@@ -45,7 +45,7 @@ class BreadthFirstEnumerator final : public arangodb::traverser::PathEnumerator
   struct PathStep {
     size_t sourceIdx;
     graph::EdgeDocumentToken edge;
-    arangodb::velocypack::StringRef const vertex;
+    arangodb::velocypack::StringRef vertex;
 
    public:
     explicit PathStep(arangodb::velocypack::StringRef const vertex);

