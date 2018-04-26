class GitlabRunner < Formula
  desc "The official GitLab CI runner written in Go"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      :tag => "v10.7.0",
      :revision => "7c273476f55ccfc0c714cbadb2a0f958ecda7732"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "73a3c6d13a7bee928ad371703db38d634c48935fc93ac11077c73cb52ff1b971" => :high_sierra
    sha256 "7626e6def25dd731875d853fc2a152d32b7b01018c4222e8e9bd971e98454b3c" => :sierra
    sha256 "3b3eb32196f063a5c4c3b696d6b1d40f1236e6199a722bda7e5d165e7f87b2d9" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "docker" => :recommended

  resource "prebuilt-x86_64.tar.xz" do
    url "https://gitlab-runner-downloads.s3.amazonaws.com/v10.7.0/docker/prebuilt-x86_64.tar.xz",
        :using => :nounzip
    version "10.7.0"
    sha256 "3b3e2a2457103b9dbe21245751ecc5bdab676dbdb6a0a68536e8a4c3506d7d17"
  end

  resource "prebuilt-arm.tar.xz" do
    url "https://gitlab-runner-downloads.s3.amazonaws.com/v10.7.0/docker/prebuilt-arm.tar.xz",
        :using => :nounzip
    version "10.7.0"
    sha256 "5fd022a00c88f02ac293b55e8fb90378118783f357ba84436975a200a48ee885"
  end

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/gitlab.com/gitlab-org/gitlab-runner"
    dir.install buildpath.children

    cd dir do
      Pathname.pwd.install resource("prebuilt-x86_64.tar.xz"),
                           resource("prebuilt-arm.tar.xz")
      system "go-bindata", "-pkg", "docker", "-nocompress", "-nomemcopy",
                           "-nometadata", "-o",
                           "#{dir}/executors/docker/bindata.go",
                           "prebuilt-x86_64.tar.xz",
                           "prebuilt-arm.tar.xz"

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
