class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v0.10.4.tar.gz"
  sha256 "8f216520622da094327caa5b6e27e0298bbd68778c7b99f436a16d6391110f99"
  head "https://github.com/hashicorp/nomad.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2b08356e6ae28a6e20d7255a6f2d5be187bfa666ca0a8b50488a801a409c0f8c" => :catalina
    sha256 "5d146a4813175e997441491a30969b9e4b10a78f1719b01d7f216ffd3ed4451e" => :mojave
    sha256 "fdbb8f133d57010138112c8d3364dbcd40b706788f284a74f8c22c104d37908e" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    src = buildpath/"src/github.com/hashicorp/nomad"
    src.install buildpath.children
    src.cd do
      system "go", "build", "-tags", "ui", "-o", bin/"nomad"
      prefix.install_metafiles
    end
  end

  plist_options :manual => "nomad agent -dev"

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
          <string>#{opt_bin}/nomad</string>
          <string>agent</string>
          <string>-dev</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/nomad.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/nomad.log</string>
      </dict>
    </plist>
  EOS
  end

  test do
    pid = fork do
      exec "#{bin}/nomad", "agent", "-dev"
    end
    sleep 10
    ENV.append "NOMAD_ADDR", "http://127.0.0.1:4646"
    system "#{bin}/nomad", "node-status"
  ensure
    Process.kill("TERM", pid)
  end
end
