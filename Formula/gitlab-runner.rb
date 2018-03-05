class GitlabRunner < Formula
  desc "The official GitLab CI runner written in Go"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      :tag => "v10.5.0",
      :revision => "80b03db9893ab1668ac601909c1a1bf29d476035"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "69b0d9adb80ee3177970bd9efd65a6369dcf03662df0eefc053ab239ef5fb7fa" => :high_sierra
    sha256 "b10dcb5cd4d988c26be5eac4ed8931f58598e08e7b12736b49c582592c82a8e7" => :sierra
    sha256 "e4c681e2dd0579d988e21b2f67bdce5e088047c53ad59c02882f54d17aa07590" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "docker" => :recommended

  resource "prebuilt-x86_64.tar.xz" do
    url "https://gitlab-runner-downloads.s3.amazonaws.com/v10.5.0/docker/prebuilt-x86_64.tar.xz",
        :using => :nounzip
    version "10.5.0"
    sha256 "60176c98a89202d195d31aca19c8977b4b1be23d0ee5f100f6efa554429c8efb"
  end

  resource "prebuilt-arm.tar.xz" do
    url "https://gitlab-runner-downloads.s3.amazonaws.com/v10.5.0/docker/prebuilt-arm.tar.xz",
        :using => :nounzip
    version "10.5.0"
    sha256 "947beebf1508cac3b22a2c06e1275a0cfb404dc023cbbb0534229df0fcfee164"
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
