class Minio < Formula
  desc "Amazon S3 compatible object storage server"
  homepage "https://github.com/minio/minio"
  url "https://github.com/minio/minio.git",
    :tag => "RELEASE.2016-10-22T00-50-41Z",
    :revision => "d1331ecc5cc4abc7304157cc26be64618821a77c"
  version "20161022005041"

  bottle do
    cellar :any_skip_relocation
    sha256 "d3cc6b58140185e010be0a0b8eebd71fe0b0d223a5d54565ff0c1703b57c4f12" => :sierra
    sha256 "bb55278468be86048e7181ee9d19060ebda62f7098673836f0b0042c69af4545" => :el_capitan
    sha256 "f78226ab1797733c9cec4ffe72050c3ddc9faf6f8d3743eb47f8b0cdfec7ade2" => :yosemite
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

        system "go", "build", "-o", buildpath/"minio", "-ldflags", <<-EOS.undent
            -X #{proj}/cmd.Version=#{version}
            -X #{proj}/cmd.ReleaseTag=#{release}
            -X #{proj}/cmd.CommitID=#{commit}
            EOS
      end
    end

    bin.install buildpath/"minio"
  end

  def post_install
    (var/"minio").mkpath
    (etc/"minio").mkpath
  end

  plist_options :manual => "minio server"

  def plist; <<-EOS.undent
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
        <string>--config-dir=etc/minio</string>
        <string>--address :9000</string>
        <string>var/minio</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>var/minio</string>
    </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/minio", "version"
  end
end
