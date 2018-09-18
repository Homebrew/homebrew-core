class Perkeep < Formula
  desc "Lets you permanently keep your stuff, for life"
  homepage "https://perkeep.org/"
  url "https://github.com/perkeep/perkeep.git",
      :tag => "0.10",
      :revision => "0cbe4d5e05a40a17efe7441d75ce0ffdf9d6b9f5"
  head "https://github.com/perkeep/perkeep.git"

  bottle do
    sha256 "1e51d2d991309cec65b66411ff9dbbd1d93ec40c4c595d1b91a786541c15d738" => :mojave
    sha256 "4db15262421ce0cefad97fd2df3affba61cba2e1ba1e4153614940cec138ae10" => :high_sierra
    sha256 "9ab629c218f4af8f769520ec269c81c6499c6c9676c5ae43da8fc7ac8212c0ff" => :sierra
    sha256 "e4e42c68017500af8a8aa7b542e89905849b09b398a547da818323f08a6e680a" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build

  conflicts_with "hello", :because => "both install `hello` binaries"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/perkeep.org").install buildpath.children
    cd "src/perkeep.org" do
      system "go", "run", "make.go"
      prefix.install_metafiles
    end
    bin.install Dir["bin/*"].select { |f| File.executable? f }
  end

  plist_options :manual => "perkeepd"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/perkeepd</string>
        <string>-openbrowser=false</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
  EOS
  end

  test do
    system bin/"pk-get", "-version"
  end
end
