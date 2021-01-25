class Perkeep < Formula
  desc "Lets you permanently keep your stuff, for life"
  homepage "https://perkeep.org/"
  license "Apache-2.0"
  head "https://github.com/perkeep/perkeep.git"

  stable do
    url "https://github.com/perkeep/perkeep.git",
        tag:      "0.11",
        revision: "76755286451a1b08e2356f549574be3eea0185e5"

    # gopherjs doesn't tag releases, so just pick the most recent revision for now
    resource "gopherjs" do
      url "https://github.com/gopherjs/gopherjs/archive/fce0ec30dd00773d3fa974351d04ce2737b5c4d9.tar.gz"
      sha256 "e5e6ede5f710fde77e48aa1f6a9b75f5afeb1163223949f76c1300ae44263b84"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "893d6cfc23b18401987de13cb5630bb259f9d3d4d0de56ebaa7d2f3f7e93333a" => :big_sur
    sha256 "9df8643ff9e18a35f5c36e7ad3f894ac9c1ca6ec005964d0d7d67e7f1df34c4a" => :arm64_big_sur
    sha256 "c676479c6b5f7e5bbee45c7b0d31b26c05915195c2ab7b61156ac46257b14cb6" => :catalina
    sha256 "e05528f7efbb84fa9bbb39a68f3d0bb48073806a204eba8d0f70a52871ed83fc" => :mojave
  end

  depends_on "go" => :build
  depends_on "pkg-config" => :build

  conflicts_with "hello", because: "both install `hello` binaries"

  def install
    if build.stable?
      ENV["GOPATH"] = buildpath
      ENV["CAMLI_GOPHERJS_GOROOT"] = Formula["go@1.12"].opt_libexec

      (buildpath/"src/perkeep.org").install buildpath.children

      # Vendored version of gopherjs requires go 1.10, so use the newest available gopherjs, which
      # supports up to go 1.12
      rm_rf buildpath/"src/perkeep.org/vendor/github.com/gopherjs/gopherjs"
      resource("gopherjs").stage buildpath/"src/perkeep.org/vendor/github.com/gopherjs/gopherjs"

      cd "src/perkeep.org" do
        system "go", "run", "make.go"
      end

      bin.install Dir["bin/*"].select { |f| File.executable? f }
    else
      system "go", "run", "make.go"
      bin.install Dir[".brew_home/go/bin/*"].select { |f| File.executable? f }
    end
  end

  plist_options manual: "perkeepd"

  def plist
    <<~EOS
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
