require "language/go"

class Consul < Formula
  desc "Tool for service discovery, monitoring and configuration"
  homepage "https://www.consul.io"
  url "https://github.com/hashicorp/consul.git",
      :tag => "v1.0.5",
      :revision => "09f90c9bfa963b895a1260cc8daffd65ac59b4bc"

  head "https://github.com/hashicorp/consul.git",
       :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "13a1f51b6ac80ee15a29d4eae30126ebd9ad26b11c6ebbc1cd4a883f13db8861" => :high_sierra
    sha256 "5cc1a651b28de83bd344fe339bc375395f55e8091b7379401596023c81536f97" => :sierra
    sha256 "d44ab7e0acba3c58b4c10e1e612c164bf2c3ac058b4bae38a2bbf558c9f1f670" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "gox" => :build

  go_resource "github.com/axw/gocov" do
    url "https://github.com/axw/gocov.git",
        :revision => "3a69a0d2a4ef1f263e2d92b041a69593d6964fe8"
  end

  go_resource "github.com/elazarl/go-bindata-assetfs" do
    url "https://github.com/elazarl/go-bindata-assetfs.git",
        :revision => "30f82fa23fd844bd5bb1e5f216db87fd77b5eb43"
  end

  go_resource "github.com/hashicorp/go-bindata" do
    url "https://github.com/hashicorp/go-bindata.git",
        :revision => "bf7910af899725e4938903fb32048c7c0b15f12e"
  end

  go_resource "github.com/magiconair/vendorfmt" do
    url "https://github.com/magiconair/vendorfmt.git",
        :revision => "0fde667441ebc14dbd64a1de758ab656b78c607b"
  end

  go_resource "github.com/matm/gocov-html" do
    url "https://github.com/matm/gocov-html.git",
        :revision => "f6dd0fd0ebc7c8cff8b24c0a585caeef250627a3"
  end

  go_resource "golang.org/x/tools" do
    url "https://go.googlesource.com/tools.git",
        :branch => "release-branch.go1.9"
  end

  def install
    # Avoid running `go get`
    inreplace "GNUmakefile", "go get -u -v $(GOTOOLS)", ""

    ENV["XC_OS"] = "darwin"
    ENV["XC_ARCH"] = MacOS.prefer_64_bit? ? "amd64" : "386"
    ENV["GOPATH"] = buildpath
    contents = Dir["{*,.git,.gitignore}"]
    (buildpath/"src/github.com/hashicorp/consul").install contents

    ENV.prepend_create_path "PATH", buildpath/"bin"
    Language::Go.stage_deps resources, buildpath/"src"

    build_tools = [
      "github.com/axw/gocov/gocov",
      "github.com/elazarl/go-bindata-assetfs/go-bindata-assetfs",
      "github.com/hashicorp/go-bindata/go-bindata",
      "github.com/magiconair/vendorfmt/cmd/vendorfmt",
      "github.com/matm/gocov-html",
      "golang.org/x/tools/cmd/cover",
      "golang.org/x/tools/cmd/stringer",
    ]

    build_tools.each do |tool|
      cd "src/#{tool}" do
        system "go", "install"
      end
    end

    cd "src/github.com/hashicorp/consul" do
      system "make"
      bin.install "bin/consul"
      prefix.install_metafiles
    end
  end

  plist_options :manual => "consul agent -dev -advertise 127.0.0.1"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <dict>
          <key>SuccessfulExit</key>
          <false/>
        </dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/consul</string>
          <string>agent</string>
          <string>-dev</string>
          <string>-advertise</string>
          <string>127.0.0.1</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/consul.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/consul.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    fork do
      exec "#{bin}/consul", "agent", "-data-dir", "."
    end
    sleep 3
    system "#{bin}/consul", "leave"
  end
end
