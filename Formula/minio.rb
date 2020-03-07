class Minio < Formula
  desc "Amazon S3 compatible object storage server"
  homepage "https://github.com/minio/minio"
  url "https://github.com/minio/minio.git",
      :tag      => "RELEASE.2020-03-06T22-23-56Z",
      :revision => "88ae0f1196103faa29cec1befb6c1f13510deb56"
  version "20200306222356"

  bottle do
    cellar :any_skip_relocation
    sha256 "70e06dd5f0afad46fbe7490332f861eca45af551271610ce6da6f523d6bf06e6" => :catalina
    sha256 "b433955a7cfc55965268716c52887900fdca8126425f9bb668f9e9f65dfcd3cd" => :mojave
    sha256 "164c57d8f00ced6ffd69579ff05b49ae9c509a06082d80ef87679532b5c25772" => :high_sierra
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
