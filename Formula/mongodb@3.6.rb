class MongodbAT36 < Formula
  desc "High-performance, schema-free, document-oriented database"
  homepage "https://www.mongodb.org/"
  url "https://fastdl.mongodb.org/src/mongodb-src-r3.6.9.tar.gz"
  sha256 "b5da7cf4323bd0958a38957e74107a149936d576db2a51fdabf2ea10a8f1eae4"

  bottle do
    sha256 "0b494089cd797aabe923075ba00d32a0edf5d9d2e7b5473d49bd27336cefc993" => :mojave
    sha256 "494292de2eff348bfa0f29d13d694d7a86719df58c147231a1f749a24e0f9382" => :high_sierra
    sha256 "67da2bba59034da2e27b7379774bfe2908c855b72a3e06fe21f679a5aafcc269" => :sierra
  end

  keg_only :versioned_formula

  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "scons" => :build
  depends_on :xcode => ["8.3.2", :build]
  depends_on :macos => :mountain_lion
  depends_on "openssl"
  depends_on "python@2"

  resource "Cheetah" do
    url "https://files.pythonhosted.org/packages/cd/b0/c2d700252fc251e91c08639ff41a8a5203b627f4e0a2ae18a6b662ab32ea/Cheetah-2.4.4.tar.gz"
    sha256 "be308229f0c1e5e5af4f27d7ee06d90bb19e6af3059794e5fd536a6f29a9b550"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/9e/a3/1d13970c3f36777c583f136c136f804d70f500168edc1edea6daa7200769/PyYAML-3.13.tar.gz"
    sha256 "3ef3092145e9b70e3ddd2c7ad59bdd0252a94dfe3949721633e41344de00a6bf"
  end

  resource "typing" do
    url "https://files.pythonhosted.org/packages/bf/9b/2bf84e841575b633d8d91ad923e198a415e3901f228715524689495b4317/typing-3.6.6.tar.gz"
    sha256 "4027c5f6127a6267a435201981ba156de91ad0d1d98e9ddc2aa173453453492d"
  end

  needs :cxx11

  def install
    ENV.cxx11 if MacOS.version < :mavericks

    ENV.libcxx

    ["Cheetah", "PyYAML", "typing"].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(buildpath/"vendor")
      end
    end
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
      --prefix=#{prefix}
      --ssl
      --use-new-tools
      CC=#{ENV.cc}
      CXX=#{ENV.cxx}
      CCFLAGS=-mmacosx-version-min=#{MacOS.version}
      LINKFLAGS=-mmacosx-version-min=#{MacOS.version}
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
    system "#{bin}/mongod", "--sysinfo"
  end
end
