class Minio < Formula
  desc "Amazon S3 compatible object storage server"
  homepage "https://github.com/minio/minio"
  url "https://github.com/minio/minio.git",
      :tag      => "RELEASE.2020-03-06T22-23-56Z",
      :revision => "88ae0f1196103faa29cec1befb6c1f13510deb56"
  version "20200306222356"

  bottle do
    cellar :any_skip_relocation
    sha256 "1122f40761acbe4db605bf15a990c5fb372f95f278c86967e53493bce7660a0f" => :catalina
    sha256 "c066e68071e91901082bdaefdbeaa94e962588fdd78b3c0b2e63fc2162cae6a3" => :mojave
    sha256 "ac4e7a09a585a6593c95760dcb6dbbfaf707ea8c696cd3c2262fc3bfdd5a92e5" => :high_sierra
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
