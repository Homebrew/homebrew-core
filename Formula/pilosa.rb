require "language/go"

class Pilosa < Formula
  desc "Distributed bitmap index that queries across data sets"
  homepage "https://www.pilosa.com"
  url "https://github.com/pilosa/pilosa/archive/v0.8.1.tar.gz"
  sha256 "52ff3b46a4ba05a056afa96609d7f9c73b9b4650b5b4af54c1a0cea58907357b"

  bottle do
    cellar :any_skip_relocation
    sha256 "e20e744e82449c1ce0a60b6086df9d30c71ca8da06bd3850e87dd75bd4556e00" => :high_sierra
    sha256 "aa75078a4834c9b8033e2f3a076072ac290ce9fe5d5cbc86799cfe94982cbe9b" => :sierra
    sha256 "d7ad7bce575ee00a0580404799ecad8aaddba131c88f1075a4fe56e499f31f32" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "dep" => :build

  go_resource "github.com/rakyll/statik" do
    url "https://github.com/rakyll/statik.git",
        :tag => "v0.1.1"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV.prepend_path "PATH", "#{buildpath}/bin"

    (buildpath/"src/github.com/pilosa/pilosa").install buildpath.children
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/rakyll/statik" do
      system "go", "install"
    end
    cd "src/github.com/pilosa/pilosa" do
      system "make", "generate-statik", "pilosa", "FLAGS=-o #{bin}/pilosa", "VERSION=v#{version}"
    end
  end

  plist_options :manual => "pilosa server"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/pilosa</string>
            <string>server</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <dict>
            <key>SuccessfulExit</key>
            <false/>
        </dict>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
      </dict>
    </plist>
    EOS
  end

  test do
    begin
      server = fork do
        exec "#{bin}/pilosa", "server"
      end
      sleep 0.5
      assert_match("Welcome. Pilosa is running.", shell_output("curl localhost:10101"))
      assert_match("<!DOCTYPE html>", shell_output("curl --user-agent NotCurl localhost:10101"))
    ensure
      Process.kill "TERM", server
      Process.wait server
    end
  end
end
