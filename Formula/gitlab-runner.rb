class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v14.0.1",
      revision: "c1edb47838c7a0862e0bea80622f98798f34fd4e"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "13539c0277ea63f695de0912431f2a96742fb5dec8adc5f060775e6a831c0124"
    sha256 cellar: :any_skip_relocation, big_sur:       "e9cbfd5a7839cc1d4f11216892bd4f6ef5d619b248f994559eeae6355ed8bd01"
    sha256 cellar: :any_skip_relocation, catalina:      "c2e6a2e58e7f2f1517ece07b534df58524b8aac95e718b678b09e88b76e6deac"
    sha256 cellar: :any_skip_relocation, mojave:        "48c2c70fdf6d375b8b8598aec6c5a0822dfaba2a642f6feff9cc343f681f51f2"
  end

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
