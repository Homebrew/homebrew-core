class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v13.9.0",
      revision: "2ebc4dc45bd6065afa304a5bfdb846334981529e"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f33d6880cae9fbed3b58162ccf1016ac1a5759412fd108fc5c4f544a45dfca66"
    sha256 cellar: :any_skip_relocation, big_sur:       "572eb3014382b91d4475fc8ef88aa359d8f24d66c290b2a74e084be4ae8826d2"
    sha256 cellar: :any_skip_relocation, catalina:      "539d16ba765ed9a15cbd9575cfc00e59fa63394514b9d7d12458c6363cff5478"
    sha256 cellar: :any_skip_relocation, mojave:        "b584ec47826383ebf7d7743409fe222c990d5613a6dbd0bb600047d5886ca335"
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
