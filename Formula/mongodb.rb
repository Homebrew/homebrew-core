require "language/go"

class Mongodb < Formula
  desc "High-performance, schema-free, document-oriented database"
  homepage "https://www.mongodb.org/"

  stable do
    url "https://fastdl.mongodb.org/src/mongodb-src-r3.4.6.tar.gz"
    sha256 "8170360f6dfede9c19c131f3d76831e952b3f1494925aa7e2a3a2f95b58ad901"

    go_resource "github.com/mongodb/mongo-tools" do
      url "https://github.com/mongodb/mongo-tools.git",
          :tag => "r3.4.6",
          :revision => "29b8883c560319b016f8bd4927807fa36f1a682f",
          :shallow => false
    end
  end

  bottle do
    sha256 "ccc7f6ca2c7c22f4432c901de76c12ff8e6e8029c802bde847cbb5f314150fbe" => :sierra
    sha256 "0907d719c9a20b3aaac5e6af8d0e90fc608ce7c5a5a0aa71e2b36a85fee07d80" => :el_capitan
    sha256 "f263ea38657836428457afcef63228afb584c4b27abe54b30729122f7fa417f6" => :yosemite
  end

  devel do
    url "https://fastdl.mongodb.org/src/mongodb-src-r3.5.9.tar.gz"
    sha256 "3b1805a5b84248207da976d8ff40781cb19d2d9004dadae074b4a2406a756e47"

    depends_on :xcode => ["8.3.2", :build]

    resource "PyYAML" do
      url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
      sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
    end

    resource "typing" do
      url "https://files.pythonhosted.org/packages/17/75/3698d7992a828ad6d7be99c0a888b75ed173a9280e53dbae67326029b60e/typing-3.6.1.tar.gz"
      sha256 "c36dec260238e7464213dcd50d4b5ef63a507972f5780652e835d0228d0edace"
    end

    go_resource "github.com/mongodb/mongo-tools" do
      url "https://github.com/mongodb/mongo-tools.git",
        :tag => "r3.5.9",
        :revision => "8bda55730d30c414a71dfbe6f45f5c54ef97811d"
    end
  end

  option "with-boost", "Compile using installed boost, not the version shipped with mongodb"
  option "with-sasl", "Compile with SASL support"

  depends_on "boost" => :optional
  depends_on "go" => :build
  depends_on :macos => :mountain_lion
  depends_on "scons" => :build
  depends_on "openssl" => :recommended

  needs :cxx11

  def install
    ENV.cxx11 if MacOS.version < :mavericks

    if build.devel?
      ENV.libcxx

      ["PyYAML", "typing"].each do |r|
        resource(r).stage do
          system "python", *Language::Python.setup_install_args(buildpath/"vendor")
        end
      end
    end
    (buildpath/".brew_home/Library/Python/2.7/lib/python/site-packages/vendor.pth").write <<-EOS.undent
      import site; site.addsitedir("#{buildpath}/vendor/lib/python2.7/site-packages")
    EOS

    # New Go tools have their own build script but the server scons "install" target is still
    # responsible for installing them.
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/mongodb/mongo-tools" do
      args = %w[]

      if build.with? "openssl"
        args << "ssl"
        ENV["LIBRARY_PATH"] = Formula["openssl"].opt_lib
        ENV["CPATH"] = Formula["openssl"].opt_include
      end

      args << "sasl" if build.with? "sasl"

      system "./build.sh", *args
    end

    mkdir "src/mongo-tools"
    cp Dir["src/github.com/mongodb/mongo-tools/bin/*"], "src/mongo-tools/"

    args = %W[
      --prefix=#{prefix}
      -j#{ENV.make_jobs}
    ]

    args << "--osx-version-min=#{MacOS.version}" if build.stable?
    args << "CCFLAGS=-mmacosx-version-min=#{MacOS.version}" if build.devel?
    args << "LINKFLAGS=-mmacosx-version-min=#{MacOS.version}" if build.devel?
    args << "CC=#{ENV.cc}"
    args << "CXX=#{ENV.cxx}"

    args << "--use-sasl-client" if build.with? "sasl"
    args << "--use-system-boost" if build.with? "boost"
    args << "--use-new-tools"
    args << "--disable-warnings-as-errors" if MacOS.version >= :yosemite

    if build.with? "openssl"
      args << "--ssl"

      args << "CCFLAGS=-I#{Formula["openssl"].opt_include}"
      args << "LINKFLAGS=-L#{Formula["openssl"].opt_lib}"
    end

    scons "install", *args

    (buildpath+"mongod.conf").write mongodb_conf
    etc.install "mongod.conf"

    (var+"mongodb").mkpath
    (var+"log/mongodb").mkpath
  end

  def mongodb_conf; <<-EOS.undent
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

  plist_options :manual => "mongod --config #{HOMEBREW_PREFIX}/etc/mongod.conf"

  def plist; <<-EOS.undent
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
