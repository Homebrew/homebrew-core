class GitlabRunner < Formula
  desc "The official GitLab CI runner written in Go"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      :tag      => "v11.9.0",
      :revision => "692ae235b7adebfbf33fde34c40230e4dd7d2638"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "409671b7d38d6e7b6949482ac89f4042969b261832ee7f26cbbafd9003095863" => :mojave
    sha256 "27868cbc4aa5374aefa900554f41e3992bfa6fad62211c49cf3c9fb175af7e46" => :high_sierra
    sha256 "6248d173a3c8684e3614c700c5d1ecdcc463007797e65df641bb6b5f6726d9b6" => :sierra
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
      </dict>
    </plist>
  EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlab-runner --version")
  end
end
