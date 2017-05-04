require "language/go"

class Kcptun < Formula
  desc "Extremely simple & fast UDP tunnel based on KCP protocol"
  homepage "https://github.com/xtaci/kcptun"
  url "https://github.com/xtaci/kcptun/archive/v20160701.tar.gz"
  sha256 "865ad3dccd5bdd96075e7653da3b8ff4aaff576413c3b4e330d993e6f5209f68"
  head "https://github.com/xtaci/kcptun.git"

  depends_on "go" => :build

  go_resource "golang.org/x/crypto" do
    url "https://github.com/golang/crypto.git",
      :revision => "2c99acdd1e9b90d779ca23f632aad86af9909c62"
  end

  go_resource "github.com/golang/snappy" do
    url "https://github.com/golang/snappy.git",
      :revision => "d9eb7a3d35ec988b8585d4a0068e462c27d28380"
  end

  go_resource "github.com/hashicorp/yamux" do
    url "https://github.com/hashicorp/yamux.git",
      :revision => "badf81fca035b8ebac61b5ab83330b72541056f4"
  end

  go_resource "github.com/urfave/cli" do
    url "https://github.com/urfave/cli.git",
      :revision => "3a5216227e14699bf7810b2573db60bf4b3f71b5"
  end

  go_resource "github.com/xtaci/kcp-go" do
    url "https://github.com/xtaci/kcp-go.git",
      :revision => "9b06339142a3461f727cda16ee11d8d402f8bbbe"
  end

  go_resource "github.com/klauspost/crc32" do
    url "https://github.com/klauspost/crc32.git",
      :revision => "19b0b332c9e4516a6370a0456e6182c3b5036720"
  end

  go_resource "github.com/klauspost/reedsolomon" do
    url "https://github.com/klauspost/reedsolomon.git",
      :revision => "467733eb9c209042fb37d2074a5b6be33a529be0"
  end

  go_resource "github.com/klauspost/cpuid" do
    url "https://github.com/klauspost/cpuid.git",
      :revision => "09cded8978dc9e80714c4d85b0322337b0a1e5e0"
  end

  go_resource "golang.org/x/net" do
    url "https://github.com/golang/net.git",
      :revision => "f841c39de738b1d0df95b5a7187744f0e03d8112"
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
