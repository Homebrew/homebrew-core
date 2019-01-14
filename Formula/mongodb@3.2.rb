require "language/go"

class MongodbAT32 < Formula
  desc "High-performance, schema-free, document-oriented database"
  homepage "https://www.mongodb.org/"
  url "https://fastdl.mongodb.org/src/mongodb-src-r3.2.21.tar.gz"
  sha256 "8263befc10319809ea14e5cbf230c55113de7b38510b42a6ad27125dfa674371"

  bottle do
    sha256 "6068932526af487dd50264aa1ead11dc199ed2bab849fd0adc04b67f90a89113" => :mojave
    sha256 "3cc0ca816b495f169afc2d5f4b92463808424f5993ee9d3ec3f8b70354a89fcd" => :high_sierra
    sha256 "d36d4031c58cee0a35b3f0445f995efad701eb519da8e3b66cf8eeb558092e6e" => :sierra
    sha256 "8fc6948abb95eca2ecdfdf4411e9ff958616dc5a917376786546e981222852c8" => :el_capitan
  end

  keg_only :versioned_formula

  depends_on "go" => :build
  depends_on "scons" => :build
  depends_on :macos => :mountain_lion
  depends_on "openssl"

  go_resource "github.com/mongodb/mongo-tools" do
    url "https://github.com/mongodb/mongo-tools.git",
        :tag      => "r3.2.21",
        :revision => "f207093c46939fd42f12980a058370c013c26338",
        :shallow  => false
  end

  needs :cxx11

  def install
    ENV.cxx11 if MacOS.version < :mavericks

    # New Go tools have their own build script but the server scons "install"
    # target is still responsible for installing them.
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/mongodb/mongo-tools" do
      ENV["LIBRARY_PATH"] = Formula["openssl"].opt_lib
      ENV["CPATH"] = Formula["openssl"].opt_include

      system "./build.sh", "ssl"
    end

    mkdir "src/mongo-tools"
    cp Dir["src/github.com/mongodb/mongo-tools/bin/*"], "src/mongo-tools/"

    args = %W[
      -j#{ENV.make_jobs}
      --osx-version-min=#{MacOS.version}
      --prefix=#{prefix}
      --ssl
      --use-new-tools
      CC=#{ENV.cc}
      CXX=#{ENV.cxx}
      CCFLAGS=-I#{Formula["openssl"].opt_include}
      LINKFLAGS=-L#{Formula["openssl"].opt_lib}
    ]

    args << "--disable-warnings-as-errors" if MacOS.version >= :yosemite

    system "scons", "install", *args

    (buildpath/"mongod.conf").write mongodb_conf
    etc.install "mongod.conf"

    (var/"mongodb").mkpath
    (var/"log/mongodb").mkpath
  end

  def mongodb_conf; <<~EOS
    systemLog:
      destination: file
      path: #{var}/log/mongodb/mongo.log
      logAppend: true
    storage:
      dbPath: #{var}/mongodb
    net:
      bindIp: 127.0.0.1
  EOS
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/mongodb@3.2/bin/mongod --config #{HOMEBREW_PREFIX}/etc/mongod.conf"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/mongod</string>
        <string>--config</string>
        <string>#{etc}/mongod.conf</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <false/>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/mongodb/output.log</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/mongodb/output.log</string>
      <key>HardResourceLimits</key>
      <dict>
        <key>NumberOfFiles</key>
        <integer>4096</integer>
      </dict>
      <key>SoftResourceLimits</key>
      <dict>
        <key>NumberOfFiles</key>
        <integer>4096</integer>
      </dict>
    </dict>
    </plist>
  EOS
  end

  test do
    system "#{bin}/mongod", "--sysinfo"
  end
end
