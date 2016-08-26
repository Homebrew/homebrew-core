require "language/go"

class Kcptun < Formula
  desc "Extremely simple & fast UDP tunnel based on KCP protocol"
  homepage "https://github.com/xtaci/kcptun"
  url "https://github.com/xtaci/kcptun/archive/v20160823.tar.gz"
  sha256 "09f3266472f318af9d30f67bea69aab9985ff62569973dfeb58413ee066d9d48"
  head "https://github.com/xtaci/kcptun.git"

  depends_on "go" => :build

  go_resource "golang.org/x/crypto" do
    url "https://github.com/golang/crypto.git"
  end

  go_resource "github.com/golang/snappy" do
    url "https://github.com/golang/snappy.git"
  end

  go_resource "github.com/xtaci/yamux" do
    url "https://github.com/xtaci/yamux.git"
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

    (buildpath/"kcptun.sh").write <<-EOS.undent
      #!/bin/sh

      local_addr=":12948"
      remote_addr="vps:29900"
      key="it's a secret"
      crypt="aes"
      mode="fast2"
      conn=1
      mtu=1350
      sndwnd=128
      rcvwnd=1024
      nocomp=""
      datashard=10
      parityshard=3
      dscp=0

    EOS

    etc.install "kcptun.sh"

    (bin/"kcptun").write <<-EOS.undent
      #!/bin/sh
      source #{etc}/kcptun.sh
      #{bin}/kcptun_client -l ${local_addr} -r ${remote_addr} --key ${key} --crypt ${crypt} --mtu ${mtu} --sndwnd ${sndwnd} --rcvwnd ${rcvwnd} --mode ${mode}${nocomp}
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
