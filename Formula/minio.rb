class Minio < Formula
  desc "Amazon S3 compatible object storage server"
  homepage "https://github.com/minio/minio"
  url "https://github.com/minio/minio.git",
      :tag      => "RELEASE.2020-01-03T19-12-21Z",
      :revision => "b00cda8ad49ed0defa9df5e7230f8b536b8ccb17"
  version "20200103191221"

  bottle do
    cellar :any_skip_relocation
    sha256 "b522ff69deef97ffdc4e72a001d554294bf6d648f8a6e2cff904d5ae620d54b9" => :catalina
    sha256 "47dd093034b9b4afdaf0ff80501393e87592f0a811e3931e505ef8128d6f98a7" => :mojave
    sha256 "01ed054d03e061508aaf60719ce1966092e65485af91dc06d87908a8e35d831a" => :high_sierra
  end

  depends_on "go" => :build

  def install
    if build.head?
      system "go", "build", "-trimpath", "-o", bin/"minio"
    else
      release = `git tag --points-at HEAD`.chomp
      version = release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)\-(\d+)\-(\d+)Z/, 'T\1:\2:\3Z')
      commit = `git rev-parse HEAD`.chomp
      proj = "github.com/minio/minio"

      system "go", "build", "-trimpath", "-o", bin/"minio", "-ldflags", <<~EOS
        -X #{proj}/cmd.Version=#{version}
        -X #{proj}/cmd.ReleaseTag=#{release}
        -X #{proj}/cmd.CommitID=#{commit}
      EOS
    end

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
            <string>--address=:9000</string>
            <string>#{var}/minio</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{HOMEBREW_PREFIX}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/minio.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/minio.log</string>
          <key>RunAtLoad</key>
          <true/>
        </dict>
      </plist>
    EOS
  end

  test do
    system "#{bin}/minio", "--version"
  end
end
