class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v13.12.0",
      revision: "7a6612da06043f908b740629bbe3f0d9c59a5dad"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "06a0c36e21fe7890a6db42248340f76d69866cee75fc5c256b75709f91b39a68"
    sha256 cellar: :any_skip_relocation, big_sur:       "4692746389a5a21651a2c38f35e1fcbd184a5528620cd46eac53d13c0fc669ab"
    sha256 cellar: :any_skip_relocation, catalina:      "294f72df991ce1480295b4cc62a9c747d0d24e2608ee54bc83a375042788dbff"
    sha256 cellar: :any_skip_relocation, mojave:        "a4963e7cd773241ddcb59da7ba4430d6a1b6551bef0d48d724922fa707a0e7b1"
  end

  depends_on "go" => :build

  def install
    dir = buildpath/"src/gitlab.com/gitlab-org/gitlab-runner"
    dir.install buildpath.children

    cd dir do
      proj = "gitlab.com/gitlab-org/gitlab-runner"
      system "go", "build", "-ldflags", <<~EOS
        -X #{proj}/common.NAME=gitlab-runner
        -X #{proj}/common.VERSION=#{version}
        -X #{proj}/common.REVISION=#{Utils.git_short_head(length: 8)}
        -X #{proj}/common.BRANCH=#{version.major}-#{version.minor}-stable
        -X #{proj}/common.BUILT=#{Time.new.strftime("%Y-%m-%dT%H:%M:%S%:z")}
      EOS

      bin.install "gitlab-runner"
    end
  end

  plist_options manual: "gitlab-runner start"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>SessionCreate</key><false/>
          <key>KeepAlive</key><true/>
          <key>RunAtLoad</key><true/>
          <key>Disabled</key><false/>
          <key>LegacyTimers</key><true/>
          <key>ProcessType</key>
          <string>Interactive</string>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/gitlab-runner</string>
            <string>run</string>
            <string>--working-directory</string>
            <string>#{ENV["HOME"]}</string>
            <string>--config</string>
            <string>#{ENV["HOME"]}/.gitlab-runner/config.toml</string>
            <string>--service</string>
            <string>gitlab-runner</string>
            <string>--syslog</string>
          </array>
          <key>EnvironmentVariables</key>
            <dict>
              <key>PATH</key>
              <string>/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
          </dict>
        </dict>
      </plist>
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlab-runner --version")
  end
end
