class Minio < Formula
  desc "Amazon S3 compatible object storage server"
  homepage "https://github.com/minio/minio"
  url "https://github.com/minio/minio.git",
      :tag      => "RELEASE.2019-07-24T02-02-23Z",
      :revision => "3e3fbdf8e6e5e889232eb7afc0b27ac054adfda0"
  version "20190724020223"

  bottle do
    cellar :any_skip_relocation
    sha256 "26d28373aa3ed6088babb649382c1fc3eb33df5a5fe058f72092545191faebd8" => :mojave
    sha256 "d4af7e5d4f13ba8ee163c9c14059446b2ece15526eb49620a9bc48da9d634e58" => :high_sierra
    sha256 "9d4394ff52414504bb312d85863b4f1f20fefb617c14e8c68cbc04b802f98de9" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"
    src = buildpath/"src/github.com/minio/minio"
    src.install buildpath.children
    src.cd do
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
    system "#{bin}/minio", "version"
  end
end
