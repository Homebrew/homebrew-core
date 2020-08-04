class Minio < Formula
  desc "High Performance, Kubernetes Native Object Storage"
  homepage "https://min.io"
  url "https://github.com/minio/minio.git",
      tag:      "RELEASE.2020-07-31T03-39-05Z",
      revision: "a8dd7b3eda4e665dbf434815bd832515f883bfc6"
  version "20200731033905"
  license "Apache-2.0"
  head "https://github.com/minio/minio.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c31a704e09d8b4222ee5cc8e8f4de05d19fb659c425279b0567d8ad4e03c6656" => :catalina
    sha256 "8d0c2e83f8d8c16970f7c82217d2071850c9cff1e269959e409360e46d0ec0af" => :mojave
    sha256 "ced8af3f62e3da270fd341282c2ae6743f32fa928177eee5becffbdaa3bf46f5" => :high_sierra
  end

  depends_on "go" => :build

  def install
    if build.head?
      system "go", "build", *std_go_args
    else
      release = `git tag --points-at HEAD`.chomp
      version = release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')
      commit = `git rev-parse HEAD`.chomp
      proj = "github.com/minio/minio"

      system "go", "build", *std_go_args, "-ldflags", <<~EOS
        -X #{proj}/cmd.Version=#{version}
        -X #{proj}/cmd.ReleaseTag=#{release}
        -X #{proj}/cmd.CommitID=#{commit}
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
    system "#{bin}/minio", "--version"
  end
end
