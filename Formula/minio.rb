class Minio < Formula
  desc "object storage server compatible with Amazon S3"
  homepage "https://github.com/minio/minio"
  url "https://github.com/minio/minio.git",
    :tag => "RELEASE.2016-09-11T17-42-18Z",
    :revision => "85e2d886bcb005d49f3876d6849a2b5a55e03cd3"
  version "20160911174218"

  bottle do
    cellar :any_skip_relocation
    sha256 "d236098663cc6b4a4016855e1f5ce21608b42e1a4d33aa24e4c9963de7bd0d14" => :el_capitan
    sha256 "a1f3a72ebd68b63b6ef658b218f7d67031d3d9ed8c95c142764bf777b3cd0ddc" => :yosemite
    sha256 "51ae709a683eb435d915377745f66d28c0ae1ca3b1d8e4f28f7b014908baf323" => :mavericks
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
