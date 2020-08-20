class GitlabRunner < Formula
  desc "The official GitLab CI runner written in Go"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v13.3.0",
      revision: "86ad88ea230a89dc97f700bdb6375dd0be7a25c7"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d9de7290a1c3e62e34a9e897af4605548890fe40bdc44f1b52ee9d8a3064fd01" => :catalina
    sha256 "d4b47740a9b6fa74b0f1cce2f28c5593c64c842acc035929799765e53564fb90" => :mojave
    sha256 "0e51ab0b8da4296107535a021f6df449bf2cc6197271de3f82d8dff3904b4f80" => :high_sierra
  end

  depends_on "go" => :build

  def install
    dir = buildpath/"src/gitlab.com/gitlab-org/gitlab-runner"
    dir.install buildpath.children

    cd dir do
      proj = "gitlab.com/gitlab-org/gitlab-runner"
      commit = Utils.safe_popen_read("git", "rev-parse", "--short=8", "HEAD").chomp
      branch = version.to_s.split(".")[0..1].join("-") + "-stable"
      built = Time.new.strftime("%Y-%m-%dT%H:%M:%S%:z")
      system "go", "build", "-ldflags", <<~EOS
        -X #{proj}/common.NAME=gitlab-runner
        -X #{proj}/common.VERSION=#{version}
        -X #{proj}/common.REVISION=#{commit}
        -X #{proj}/common.BRANCH=#{branch}
        -X #{proj}/common.BUILT=#{built}
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
