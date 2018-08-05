class Mongodb < Formula
  desc "High-performance, schema-free, document-oriented database"
  homepage "https://www.mongodb.org/"
  url "https://fastdl.mongodb.org/src/mongodb-src-r4.0.1.tar.gz"
  sha256 "c9b2ab4ea6899b631e77b7aed3b3653eed1086a75cb0f3bf74910c49d55a7dff"

  bottle do
    sha256 "fef24dba4cdac561759718cd417bf23198c4553049dc6eec5e92b9f8a6d86df7" => :high_sierra
    sha256 "04dbbfdb23c17f3e7760275db91a032c5187ec14bbe6d9db181906cdbcc03c95" => :sierra
  end

  option "with-boost", "Compile using installed boost, not the version shipped with mongodb"
  option "with-sasl", "Compile with SASL support"

  depends_on :xcode => ["8.3.2", :build]
  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "scons" => :build
  depends_on :macos => :mountain_lion
  depends_on "python@2"
  depends_on "openssl" => :recommended
  depends_on "boost" => :optional

  resource "Cheetah" do
    url "https://files.pythonhosted.org/packages/cd/b0/c2d700252fc251e91c08639ff41a8a5203b627f4e0a2ae18a6b662ab32ea/Cheetah-2.4.4.tar.gz"
    sha256 "be308229f0c1e5e5af4f27d7ee06d90bb19e6af3059794e5fd536a6f29a9b550"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/9e/a3/1d13970c3f36777c583f136c136f804d70f500168edc1edea6daa7200769/PyYAML-3.13.tar.gz"
    sha256 "3ef3092145e9b70e3ddd2c7ad59bdd0252a94dfe3949721633e41344de00a6bf"
  end

  resource "typing" do
    url "https://files.pythonhosted.org/packages/ec/cc/28444132a25c113149cec54618abc909596f0b272a74c55bab9593f8876c/typing-3.6.4.tar.gz"
    sha256 "d400a9344254803a2368533e4533a4200d21eb7b6b729c173bc38201a74db3f2"
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

    # New Go tools have their own build script but the server scons "install" target is still
    # responsible for installing them.

    cd "src/mongo/gotools" do
      inreplace "build.sh" do |s|
        s.gsub! "$(git describe)", version.to_s
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
    ]

    args << "CC=#{ENV.cc}"
    args << "CXX=#{ENV.cxx}"

    args << "CCFLAGS=-mmacosx-version-min=#{MacOS.version}"
    args << "LINKFLAGS=-mmacosx-version-min=#{MacOS.version}"

    args << "--use-sasl-client" if build.with? "sasl"
    args << "--use-system-boost" if build.with? "boost"
    args << "--use-new-tools"
    args << "--build-mongoreplay=true"
    args << "--disable-warnings-as-errors" if MacOS.version >= :yosemite

    if build.with? "openssl"
      args << "--ssl"

      args << "CCFLAGS=-I#{Formula["openssl"].opt_include}"
      args << "LINKFLAGS=-L#{Formula["openssl"].opt_lib}"
    end

    scons "install", *args

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
