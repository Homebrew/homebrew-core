require "language/go"

class MongodbAT30 < Formula
  desc "High-performance document-oriented database"
  homepage "https://www.mongodb.org/"
  # do not upgrade to versions >3.0.15 as they are under the SSPL which is not
  # an open-source license.
  url "https://fastdl.mongodb.org/src/mongodb-src-r3.0.15.tar.gz"
  sha256 "09ad76e06df007085520025c94a5e5840d65f37660c2b359f4962e135e4ae259"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e9bcb40366191475e9979c44c5d03eec79844c1c72cbbaf4e8a51c78de8ab532" => :mojave
    sha256 "fa98196c3846711ffc9967865c9a91ec8e26c11afc145786b4c2a35e560ee3c7" => :high_sierra
    sha256 "08f39428cbf29286ac405724b9160a31a9658c5ce3d23c04c316d6dd30dce067" => :sierra
  end

  keg_only :versioned_formula

  depends_on "go" => :build
  depends_on "scons" => :build
  depends_on :macos => :mountain_lion

  go_resource "github.com/mongodb/mongo-tools" do
    url "https://github.com/mongodb/mongo-tools.git",
      :tag      => "r3.0.15",
      :revision => "86d15daf966ce58f5ce01985db07a7a5a3641ecb"
  end

  needs :cxx11

  def install
    ENV.cxx11 if MacOS.version < :mavericks

    # New Go tools have their own build script but the server scons "install"
    # target is still responsible for installing them.
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/mongodb/mongo-tools" do
      system "./build.sh"
    end

    mkdir "src/mongo-tools"
    cp Dir["src/github.com/mongodb/mongo-tools/bin/*"], "src/mongo-tools/"

    args = %W[
      -j#{ENV.make_jobs}
      --cc=#{ENV.cc}
      --cxx=#{ENV.cxx}
      --osx-version-min=#{MacOS.version}
      --prefix=#{prefix}
      --use-new-tools
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

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/mongodb@3.0/bin/mongod --config #{HOMEBREW_PREFIX}/etc/mongod.conf"

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
