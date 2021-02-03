class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2021-01-30T00-20-58Z",
      revision: "c82aef0a565439d27e01b7d7cfd779d6c329e028"
  version "20210130002058"
  license "Apache-2.0"
  head "https://github.com/minio/minio.git"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\d\-TZ]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "15471c8f63e7d2d7b6746cb4e6f441af4fd8ea2cc506697c2fe52c43220a35db"
    sha256 cellar: :any_skip_relocation, big_sur:       "c3c89cb18c3b44c8ff097f12c9b21f8b410b071b522ef2dc050ebc7bed8dd259"
    sha256 cellar: :any_skip_relocation, catalina:      "d8087b13fcd82e25dcade95db042f55999ec54b0b28bfea75b7f3d39404b0f04"
    sha256 cellar: :any_skip_relocation, mojave:        "471414c916d0d20128cc3fdd5aabb79a9b3eb3c9586c78d6762d587326b75bd6"
  end

  depends_on "go" => :build

  def install
    if build.head?
      system "go", "build", *std_go_args
    else
      release = `git tag --points-at HEAD`.chomp
      version = release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')
      proj = "github.com/minio/minio"

      system "go", "build", *std_go_args, "-ldflags", <<~EOS
        -X #{proj}/cmd.Version=#{version}
        -X #{proj}/cmd.ReleaseTag=#{release}
        -X #{proj}/cmd.CommitID=#{Utils.git_head}
      EOS
    end
  end

  def post_install
    (var/"minio").mkpath
    (etc/"minio").mkpath
  end

  plist_options manual: "minio server"

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
    assert_match "minio server - start object storage server",
      shell_output("#{bin}/minio server --help 2>&1")

    assert_match "minio gateway - start object storage gateway",
      shell_output("#{bin}/minio gateway 2>&1")
    assert_match "ERROR Unable to validate credentials",
      shell_output("#{bin}/minio gateway s3 2>&1", 1)
  end
end
