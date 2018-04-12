class PerconaServerMongodb < Formula
  desc "Drop-in MongoDB replacement"
  homepage "https://www.percona.com"
  url "https://www.percona.com/downloads/percona-server-mongodb-3.4/percona-server-mongodb-3.4.14-2.12/source/tarball/percona-server-mongodb-3.4.14-2.12.tar.gz"
  version "3.4.14-2.12"
  sha256 "2e728c44ec70b8b1d321c53db6521c3ec2d0db7a12d6edf54d2f49258fc0531e"

  bottle do
    sha256 "335ea0f63c973e5223dbf6864b70955fd54378f2443765451356a258afb9fd7e" => :high_sierra
    sha256 "4a6ead4ac655a9e24bd6888605fa61cbfcaf8cd03f78a59731999b69153a2e84" => :sierra
    sha256 "110a814bc2bc4220efd51de796f38a23a61cc96168787d33b998083bf124e207" => :el_capitan
  end

  option "with-boost", "Compile using installed boost, not the version shipped with this formula"
  option "with-sasl", "Compile with SASL support"

  depends_on "boost" => :optional
  depends_on "go" => :build
  depends_on :macos => :mountain_lion
  depends_on "scons" => :build
  depends_on "openssl" => :recommended

  conflicts_with "mongodb",
    :because => "percona-server-mongodb and mongodb install the same binaries."

  needs :cxx11

  def install
    ENV.cxx11 if MacOS.version < :mavericks
    ENV.libcxx if build.devel?

    # New Go tools have their own build script but the server scons "install" target is still
    # responsible for installing them.

    cd "src/mongo/gotools" do
      inreplace "build.sh" do |s|
        s.gsub! "$(git describe)", version.to_s.split("-")[0]
        s.gsub! "$(git rev-parse HEAD)", "homebrew"
      end

      args = %w[]

      if build.with? "openssl"
        args << "ssl"
        ENV["LIBRARY_PATH"] = Formula["openssl"].opt_lib
        ENV["CPATH"] = Formula["openssl"].opt_include
      end

      args << "sasl" if build.with? "sasl"

      system "./build.sh", *args
    end

    (buildpath/"src/mongo-tools").install Dir["src/mongo/gotools/bin/*"]

    args = %W[
      --prefix=#{prefix}
      -j#{ENV.make_jobs}
      --osx-version-min=#{MacOS.version}
    ]

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

    (buildpath/"mongod.conf").write <<~EOS
      systemLog:
        destination: file
        path: #{var}/log/mongodb/mongo.log
        logAppend: true
      storage:
        dbPath: #{var}/mongodb
      net:
        bindIp: 127.0.0.1
    EOS
    etc.install "mongod.conf"
  end

  def post_install
    (var/"mongodb").mkpath
    (var/"log/mongodb").mkpath
  end

  plist_options :manual => "mongod --config #{HOMEBREW_PREFIX}/etc/mongod.conf"

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
    begin
      (testpath/"mongodb_test.js").write <<~EOS
        printjson(db.getCollectionNames())
        // create test collection
        db.test.insertOne(
          {
            "name": "test"
          }
        )
        printjson(db.getCollectionNames())
        // shows documents
        cursor = db.test.find({})
        while (cursor.hasNext()) {
          printjson(cursor.next())
        }
        db.test.deleteMany({})
        // drop test collection
        db.test.drop()
        printjson(db.getCollectionNames())
      EOS
      pid = fork do
        exec "#{bin}/mongod", "--port", "27018", "--dbpath", testpath
      end
      sleep 1
      system "#{bin}/mongo", "localhost:27018", testpath/"mongodb_test.js"
    ensure
      Process.kill "SIGTERM", pid
      Process.wait pid
    end
  end
end
