class GitlabRunner < Formula
  desc "The official GitLab CI runner written in Go"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      :tag => "v11.0.0",
      :revision => "5396d320cd17c02bd4133d52b8ac9acd21b20f51"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1ba2aab706d835977e5ed368b989c7ef8faa9f2a07423e9586e941cda08073f4" => :high_sierra
    sha256 "096996e6abaac456cc6a58f4c29e1892d666d80786d6e15c33dd9474a3854fa4" => :sierra
    sha256 "8bb8f4b5097dadc7e274c5638e66c5bc3458091c658f64d8554f3fe911c8df51" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "docker" => :recommended

  resource "prebuilt-x86_64.tar.xz" do
    url "https://gitlab-runner-downloads.s3.amazonaws.com/v11.0.0/docker/prebuilt-x86_64.tar.xz",
        :using => :nounzip
    version "11.0.0"
    sha256 "4bb8b87433a2c9dcb5e3fd44b3eccb0a37d414ccc321068cf6108694d4e722f2"
  end

  resource "prebuilt-arm.tar.xz" do
    url "https://gitlab-runner-downloads.s3.amazonaws.com/v11.0.0/docker/prebuilt-arm.tar.xz",
        :using => :nounzip
    version "11.0.0"
    sha256 "6f8dc036b77af34f0bfc4468466de60f83e8480a9736e8760e5e8aa67affc7f8"
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
