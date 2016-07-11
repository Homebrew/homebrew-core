require "language/go"

class Kcptun < Formula
  desc "extremely simple & fast udp tunnel based on kcp protocol"
  homepage "https://github.com/xtaci/kcptun"
  url "https://github.com/xtaci/kcptun/archive/v20160701.tar.gz"
  sha256 "865ad3dccd5bdd96075e7653da3b8ff4aaff576413c3b4e330d993e6f5209f68"
  head "https://github.com/xtaci/kcptun.git"

  depends_on "go" => :build

  go_resource "golang.org/x/crypto" do
    url "https://github.com/golang/crypto.git"
  end

  go_resource "github.com/golang/snappy" do
    url "https://github.com/golang/snappy.git"
  end

  go_resource "github.com/hashicorp/yamux" do
    url "https://github.com/hashicorp/yamux.git"
  end

  go_resource "github.com/urfave/cli" do
    url "https://github.com/urfave/cli.git"
  end

  go_resource "github.com/xtaci/kcp-go" do
    url "https://github.com/xtaci/kcp-go.git"
  end

  go_resource "github.com/klauspost/crc32" do
    url "https://github.com/klauspost/crc32.git"
  end

  go_resource "github.com/klauspost/reedsolomon" do
    url "https://github.com/klauspost/reedsolomon.git"
  end

  go_resource "github.com/klauspost/cpuid" do
    url "https://github.com/klauspost/cpuid.git"
  end

  go_resource "golang.org/x/net" do
    url "https://github.com/golang/net.git"
  end

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/xtaci"
    ln_sf buildpath, buildpath/"src/github.com/xtaci/kcptun"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-ldflags", "-X main.VERSION=#{version} -s -w",
      "-o", "kcptun_client", "github.com/xtaci/kcptun/client"
    bin.install "kcptun_client"
    (bin/"kcptun").write <<-EOS.undent
      #!/bin/sh
      #{bin}/kcptun_client -r serverip:554 -l 127.0.0.1:1080 -mode fast2
    EOS
  end

  def caveats; <<-EOS.undent
    Now, you can use kcptun_client and kcptun (with config).
    But if you want to use kcptun, you must modify it's config first.
        vim #{opt_bin}/kcptun
    Config example:
        server: ./server_linux_amd64 -t 127.0.0.1:1080 -l :554 -mode fast2
        client: ./client_darwin_amd64 -r serverip:554 -l :1080 -mode fast2
    EOS
  end

  plist_options :manual => "kcptun"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/kcptun</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <dict>
          <key>Crashed</key>
          <true/>
          <key>SuccessfulExit</key>
          <false/>
        </dict>
        <key>ProcessType</key>
        <string>Background</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/kcptun.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/kcptun.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    assert_match "kcptun version", shell_output("#{bin}/kcptun_client -v")
  end
end
