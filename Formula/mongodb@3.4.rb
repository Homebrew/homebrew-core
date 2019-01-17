class MongodbAT34 < Formula
  desc "High-performance, schema-free, document-oriented database"
  homepage "https://www.mongodb.org/"
  # do not upgrade to versions >3.4.18 as they are under the SSPL which is not
  # an open-source license.
  url "https://fastdl.mongodb.org/src/mongodb-src-r3.4.18.tar.gz"
  sha256 "a1c17e9977307752ddac4b06bcb65be177035057c21955df5a65e2db74a20856"

  bottle do
    cellar :any
    rebuild 1
    sha256 "fb3ce36a4fa8767b53d49914000a0985934d7091a63e9e630fada9704fa861cd" => :mojave
    sha256 "5914b8f9b37c4c7b66c533f6a5fb3e643a775e6c6eb839a6b2993b5bf51665a6" => :high_sierra
    sha256 "023c524acb02fa97d24b0312310ae8dcc3cd15bba7252d2a599cf1221182e406" => :sierra
  end

  keg_only :versioned_formula

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "scons" => :build
  depends_on :macos => :mountain_lion
  depends_on "openssl"

  needs :cxx11

  def install
    ENV.cxx11 if MacOS.version < :mavericks

    (buildpath/".brew_home/Library/Python/2.7/lib/python/site-packages/vendor.pth").write <<~EOS
      import site; site.addsitedir("#{buildpath}/vendor/lib/python2.7/site-packages")
    EOS

    # New Go tools have their own build script but the server scons "install"
    # target is still responsible for installing them.

    cd "src/mongo/gotools" do
      inreplace "build.sh" do |s|
        s.gsub! "$(git describe)", version.to_s
        s.gsub! "$(git rev-parse HEAD)", "homebrew"
      end

      ENV["LIBRARY_PATH"] = Formula["openssl"].opt_lib
      ENV["CPATH"] = Formula["openssl"].opt_include

      system "./build.sh", "ssl"
    end

    (buildpath/"src/mongo-tools").install Dir["src/mongo/gotools/bin/*"]

    args = %W[
      -j#{ENV.make_jobs}
      --build-mongoreplay=true
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
  end

  def post_install
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

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/mongodb@3.4/bin/mongod --config #{HOMEBREW_PREFIX}/etc/mongod.conf"

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
