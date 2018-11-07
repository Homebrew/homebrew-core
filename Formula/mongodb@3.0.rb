require "language/go"

class MongodbAT30 < Formula
  desc "High-performance document-oriented database"
  homepage "https://www.mongodb.org/"
  url "https://fastdl.mongodb.org/src/mongodb-src-r3.0.15.tar.gz"
  sha256 "09ad76e06df007085520025c94a5e5840d65f37660c2b359f4962e135e4ae259"

  bottle do
    cellar :any_skip_relocation
    sha256 "053e7f96eac6cbc5201683fdc0e06f2fa6c8fdd903ed73ec63aadbcb52198b8f" => :mojave
    sha256 "a3c4c9fcf5c44c34f96395923937c65e7cf6cb52bd937ef2878afe91633672fe" => :high_sierra
    sha256 "51f78308884b822d7406e12c897b613445cd0cb41add89b4835a203190c658d5" => :sierra
    sha256 "3a8d91eba9e8342e325e6fe1643b63687429ce2866c61a27bef836928b264c6b" => :el_capitan
  end

  keg_only :versioned_formula

  option "with-boost", "Compile using installed boost, not the version shipped with mongodb"

  depends_on "go" => :build
  depends_on "scons" => :build
  depends_on :macos => :mountain_lion
  depends_on "boost" => :optional
  depends_on "openssl" => :optional

  go_resource "github.com/mongodb/mongo-tools" do
    url "https://github.com/mongodb/mongo-tools.git",
      :tag      => "r3.0.15",
      :revision => "86d15daf966ce58f5ce01985db07a7a5a3641ecb"
  end

  needs :cxx11

  def install
    ENV.cxx11 if MacOS.version < :mavericks

    # New Go tools have their own build script but the server scons "install" target is still
    # responsible for installing them.
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/mongodb/mongo-tools" do
      args = %w[]

      if build.with? "openssl"
        args << "ssl"
        ENV["LIBRARY_PATH"] = "#{Formula["openssl"].opt_prefix}/lib"
        ENV["CPATH"] = "#{Formula["openssl"].opt_prefix}/include"
      end
      system "./build.sh", *args
    end

    mkdir "src/mongo-tools"
    cp Dir["src/github.com/mongodb/mongo-tools/bin/*"], "src/mongo-tools/"

    args = %W[
      --prefix=#{prefix}
      -j#{ENV.make_jobs}
      --osx-version-min=#{MacOS.version}
      --cc=#{ENV.cc}
      --cxx=#{ENV.cxx}
    ]

    args << "--use-system-boost" if build.with? "boost"
    args << "--use-new-tools"
    args << "--disable-warnings-as-errors" if MacOS.version >= :yosemite

    if build.with? "openssl"
      args << "--ssl" << "--extrapath=#{Formula["openssl"].opt_prefix}"
    end

    scons "install", *args

    (buildpath+"mongod.conf").write mongodb_conf
    etc.install "mongod.conf"

    (var+"mongodb").mkpath
    (var+"log/mongodb").mkpath
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
