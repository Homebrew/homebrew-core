class GitlabRunner < Formula
  desc "The official GitLab CI runner written in Go"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      :tag      => "v12.2.0",
      :revision => "a987417a77a10898a7c959d52151b77cf5f48fb5"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8fa505fad0213c596b206745a94aa5c1fdd54a6992f0c399e08fe99c69a47dc9" => :mojave
    sha256 "f9871e81b078864e52fa026dd6c7a2f1ff28aa6b76dd56779f8d8f6ed7ff81b8" => :high_sierra
    sha256 "6a82a6af134be2ffbdb68cc3ef6257f0b91f082caba35691919712714fa78888" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/gitlab.com/gitlab-org/gitlab-runner"
    dir.install buildpath.children

    cd dir do
      proj = "gitlab.com/gitlab-org/gitlab-runner"
      commit = Utils.popen_read("git", "rev-parse", "--short", "HEAD").chomp
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
      prefix.install_metafiles
    end
  end

  plist_options :manual => "gitlab-runner start"

  def plist; <<~EOS
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
