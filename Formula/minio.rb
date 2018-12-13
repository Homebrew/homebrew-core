class Minio < Formula
  desc "Amazon S3 compatible object storage server"
  homepage "https://github.com/minio/minio"
  url "https://github.com/minio/minio.git",
      :tag      => "RELEASE.2018-12-13T02-04-19Z",
      :revision => "6f7c99a33325bb11431dd56a1d261a18e5293de3"
  version "20181213020419"

  bottle do
    cellar :any_skip_relocation
    sha256 "118adb397fc05b818e827aea708e90d9b1260085c1275d39c651bd5e59408e64" => :mojave
    sha256 "ed88b0f3d6880017a801d63f0d9f871b8c7f9ad76331b6058ceb70ebbc923b34" => :high_sierra
    sha256 "635657d78306408380100c2c7634169a92a85e9b0369dd7c0ba34bc02f765005" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    clipath = buildpath/"src/github.com/minio/minio"
    clipath.install Dir["*"]

    cd clipath do
      if build.head?
        system "go", "build", "-o", buildpath/"minio"
      else
        release = `git tag --points-at HEAD`.chomp
        version = release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)\-(\d+)\-(\d+)Z/, 'T\1:\2:\3Z')
        commit = `git rev-parse HEAD`.chomp
        proj = "github.com/minio/minio"

        system "go", "build", "-o", buildpath/"minio", "-ldflags", <<~EOS
          -X #{proj}/cmd.Version=#{version}
          -X #{proj}/cmd.ReleaseTag=#{release}
          -X #{proj}/cmd.CommitID=#{commit}
        EOS
      end
    end

    bin.install buildpath/"minio"
    prefix.install_metafiles
  end

  def post_install
    (var/"minio").mkpath
    (etc/"minio").mkpath
  end

  plist_options :manual => "minio server"

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
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/minio</string>
            <string>server</string>
            <string>--config-dir=#{etc}/minio</string>
            <string>--address :9000</string>
            <string>#{var}/minio</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{HOMEBREW_PREFIX}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/minio/output.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/minio/output.log</string>
          <key>RunAtLoad</key>
          <true/>
        </dict>
      </plist>
    EOS
  end

  test do
    system "#{bin}/minio", "version"
  end
end
