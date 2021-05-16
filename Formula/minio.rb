class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2021-05-16T05-32-34Z",
      revision: "2ab9dc76098af1e84e46dee4fea4a0acf8848cfb"
  version "20210516053234"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/minio.git"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\d\-TZ]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6c9f714bc644a8fea1f3175cb0d2d374d4a08ae0ab8b98fbc07251a7d90c3196"
    sha256 cellar: :any_skip_relocation, big_sur:       "c14b07eaff466b62398baf2c299ea9d692c08345b9c091aaeb27a3e344f28b8d"
    sha256 cellar: :any_skip_relocation, catalina:      "0334d2252abc19e615d9fa685d35bf44b4bb50c9e7610852658a24d4b0d5f617"
    sha256 cellar: :any_skip_relocation, mojave:        "b638dc30a343577f9055a022c84ffb82a40cf365ee391dcd484e9cf7221d2627"
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
