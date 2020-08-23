class Perkeep < Formula
  desc "Lets you permanently keep your stuff, for life"
  homepage "https://perkeep.org/"
  license "Apache-2.0"

  stable do
    url "https://github.com/perkeep/perkeep.git",
        tag:      "0.10",
        revision: "0cbe4d5e05a40a17efe7441d75ce0ffdf9d6b9f5"

    # gopherjs doesn't tag releases, so just pick the most recent revision for now
    resource "gopherjs" do
      url "https://github.com/gopherjs/gopherjs/archive/fce0ec30dd00773d3fa974351d04ce2737b5c4d9.tar.gz"
      sha256 "e5e6ede5f710fde77e48aa1f6a9b75f5afeb1163223949f76c1300ae44263b84"
    end

    depends_on "go@1.12" => :build
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "36f18ad54a3e656ac5da55fc438636aac922e107ad1082e0dad7353626f0db84" => :catalina
    sha256 "51f41c16b3c4ea80d6a77c5badf28dca0ec323bd5aa2f1f90e855ce568b1c8ca" => :mojave
    sha256 "b188c23945a51d253dc6c4435afaa509a2ddaf151124ef1f08a1186611041c92" => :high_sierra
  end

  head do
    url "https://github.com/perkeep/perkeep.git"

    depends_on "go" => :build
  end

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
