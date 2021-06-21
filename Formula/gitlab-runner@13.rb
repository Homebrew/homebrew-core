class GitlabRunnerAT13 < Formula
  desc "Official GitLab CI runner version 13"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v13.12.0",
      revision: "7a6612da06043f908b740629bbe3f0d9c59a5dad"
  license "MIT"

  keg_only :versioned_formula

  depends_on "go" => :build

  def install
    proj = "gitlab.com/gitlab-org/gitlab-runner"
    ldflags = [
      "-X #{proj}/common.NAME=gitlab-runner",
      "-X #{proj}/common.VERSION=#{version}",
      "-X #{proj}/common.REVISION=#{Utils.git_short_head(length: 8)}",
      "-X #{proj}/common.BRANCH=#{version.major}-#{version.minor}-stable",
      "-X #{proj}/common.BUILT=#{Time.new.strftime("%Y-%m-%dT%H:%M:%S%:z")}",
    ]

    system "go", "build", *std_go_args(ldflags: ldflags.join(" "))

    bin.install_symlink "gitlab-runner@13" => "gitlab-runner"
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
