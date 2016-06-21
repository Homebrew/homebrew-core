require "language/go"

class Kapacitor < Formula
  desc "Open source time series data processor"
  homepage "https://github.com/influxdata/kapacitor"
  url "https://github.com/influxdata/kapacitor.git",
    :tag => "v0.13.1",
    :revision => "ae7dde3aa467c46c06a5a2058a80c6125203f599"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa6712543833d0695989bb9aab2d26506eb3d8eda5b23285aae72a5029307f36" => :el_capitan
    sha256 "cc1b0e673d49992bfde43da5466472fce532e14f2b3ac8a7fe89b633500222e0" => :yosemite
    sha256 "d55e8d2a5c08ed7cad79c3ebb5d18e35798c5925434f52065fa96ab388a9c9fe" => :mavericks
  end

  devel do
    url "https://github.com/influxdata/kapacitor.git",
      :tag => "v1.0.0-beta2",
      :revision => "00860596e7ef4c9eb6380afd62a7be674738036f"

    go_resource "github.com/peterh/liner" do
      url "https://github.com/peterh/liner.git",
      :revision => "82a939e738b0ee23e84ec7a12d8e216f4d95c53f"
    end

    go_resource "github.com/dgryski/go-bits" do
      url "https://github.com/dgryski/go-bits.git",
      :revision => "2ad8d707cc05b1815ce6ff2543bb5e8d8f9298ef"
    end

    go_resource "github.com/dgryski/go-bitstream" do
      url "https://github.com/dgryski/go-bitstream.git",
      :revision => "27cd5973303fde7d914860be1ea4b927a6be0c92"
    end

    go_resource "github.com/golang/snappy" do
      url "https://github.com/golang/snappy.git",
      :revision => "d9eb7a3d35ec988b8585d4a0068e462c27d28380"
    end

    go_resource "github.com/jwilder/encoding" do
      url "https://github.com/jwilder/encoding.git",
      :revision => "ac74639f65b2180a2e5eb5ff197f0c122441aed0"
    end

    go_resource "github.com/bmizerany/pat" do
      url "https://github.com/bmizerany/pat.git",
      :revision => "c068ca2f0aacee5ac3681d68e4d0a003b7d1fd2c"
    end

    go_resource "github.com/dgrijalva/jwt-go" do
      url "https://github.com/dgrijalva/jwt-go.git",
      :revision => "a2c85815a77d0f951e33ba4db5ae93629a1530af"
    end

    go_resource "github.com/rakyll/statik" do
      url "https://github.com/rakyll/statik.git",
      :revision => "2940084503a48359b41de178874e862c5bc3efe8"
    end

    go_resource "collectd.org" do
      url "https://github.com/collectd/go-collectd.git",
      :revision => "9fc824c70f713ea0f058a07b49a4c563ef2a3b98"
    end

    go_resource "github.com/paulbellamy/ratecounter" do
      url "https://github.com/paulbellamy/ratecounter.git",
      :revision => "5a11f585a31379765c190c033b6ad39956584447"
    end

    go_resource "github.com/shurcooL/github_flavored_markdown" do
      url "https://github.com/shurcooL/github_flavored_markdown.git",
      :revision => "b3921bea4a899100a4fd522dd940b819af56e437"
    end

    go_resource "github.com/shurcooL/gopherjslib" do
      url "https://github.com/shurcooL/gopherjslib.git",
      :revision => "f855ed7bcd82b53f720f6bf4a0c9b562e89276f6"
    end

    go_resource "golang.org/x/net" do
      url "https://go.googlesource.com/net.git",
      :revision => "7c71ca708c71bcbd0e6c856b01468ee07fe24557"
    end

    go_resource "github.com/gopherjs/gopherjs" do
      url "https://github.com/gopherjs/gopherjs.git",
      :revision => "ad712376c7b3218a7278e98928593a9959993a74"
    end

    go_resource "honnef.co/go/js/dom" do
      url "https://github.com/dominikh/go-js-dom.git",
      :revision => "24aa052bc5c63cfb9383bf59493ee48621ca788c"
    end

    go_resource "golang.org/x/tools" do
      url "https://go.googlesource.com/tools.git",
      :revision => "a2a552218a0e22e6fb22469f49ef371b492f6178"
    end

    go_resource "gopkg.in/pipe.v2" do
      url "https://gopkg.in/pipe.v2.git",
      :revision => "3c2ca4d525447ec8b2f606a6974f9c9f40831f26"
    end

    go_resource "github.com/shurcooL/httpfs" do
      url "https://github.com/shurcooL/httpfs.git",
      :revision => "f4a60bdbdd5a8f203c1ad5b6c95232f346eae1f5"
    end

    go_resource "github.com/microcosm-cc/bluemonday" do
      url "https://github.com/microcosm-cc/bluemonday.git",
      :revision => "4ac6f27528d0a3f2a59e0b0a6f6b3ff0bb89fe20"
    end

    go_resource "github.com/shurcooL/highlight_diff" do
      url "https://github.com/shurcooL/highlight_diff.git",
      :revision => "d2b0c68f5806a510c01992ecd0ca0e362eea8d56"
    end

    go_resource "github.com/shurcooL/highlight_go" do
      url "https://github.com/shurcooL/highlight_go.git",
      :revision => "1957344892ab030408ce1c7e0f93d56fb5ca1120"
    end

    go_resource "github.com/sourcegraph/annotate" do
      url "https://github.com/sourcegraph/annotate.git",
      :revision => "f4cad6c6324d3f584e1743d8b3e0e017a5f3a636"
    end

    go_resource "github.com/sourcegraph/syntaxhighlight" do
      url "https://github.com/sourcegraph/syntaxhighlight.git",
      :revision => "637a8b8b94eca8bb8cd559b950cc4f42629ec137"
    end

    go_resource "github.com/fsnotify/fsnotify" do
      url "https://github.com/fsnotify/fsnotify.git",
      :revision => "30411dbcefb7a1da7e84f75530ad3abe4011b4f8"
    end

    go_resource "github.com/kardianos/osext" do
      url "https://github.com/kardianos/osext.git",
      :revision => "29ae4ffbc9a6fe9fb2bc5029050ce6996ea1d3bc"
    end

    go_resource "github.com/neelance/sourcemap" do
      url "https://github.com/neelance/sourcemap.git",
      :revision => "8c68805598ab8d5637b1a72b5f7d381ea0f39c31"
    end

    go_resource "github.com/sergi/go-diff" do
      url "https://github.com/sergi/go-diff.git",
      :revision => "ec7fdbb58eb3e300c8595ad5ac74a5aa50019cc7"
    end

    go_resource "golang.org/x/sys" do
      url "https://go.googlesource.com/sys.git",
      :revision => "62bee037599929a6e9146f29d10dd5208c43507d"
    end
  end

  head do
    url "https://github.com/influxdata/kapacitor.git",
    :version => "v1.0.0-HEAD"

    go_resource "github.com/peterh/liner" do
      url "https://github.com/peterh/liner.git",
      :revision => "82a939e738b0ee23e84ec7a12d8e216f4d95c53f"
    end

    go_resource "github.com/dgryski/go-bits" do
      url "https://github.com/dgryski/go-bits.git",
      :revision => "2ad8d707cc05b1815ce6ff2543bb5e8d8f9298ef"
    end

    go_resource "github.com/dgryski/go-bitstream" do
      url "https://github.com/dgryski/go-bitstream.git",
      :revision => "27cd5973303fde7d914860be1ea4b927a6be0c92"
    end

    go_resource "github.com/golang/snappy" do
      url "https://github.com/golang/snappy.git",
      :revision => "d9eb7a3d35ec988b8585d4a0068e462c27d28380"
    end

    go_resource "github.com/jwilder/encoding" do
      url "https://github.com/jwilder/encoding.git",
      :revision => "ac74639f65b2180a2e5eb5ff197f0c122441aed0"
    end

    go_resource "github.com/bmizerany/pat" do
      url "https://github.com/bmizerany/pat.git",
      :revision => "c068ca2f0aacee5ac3681d68e4d0a003b7d1fd2c"
    end

    go_resource "github.com/dgrijalva/jwt-go" do
      url "https://github.com/dgrijalva/jwt-go.git",
      :revision => "a2c85815a77d0f951e33ba4db5ae93629a1530af"
    end

    go_resource "github.com/rakyll/statik" do
      url "https://github.com/rakyll/statik.git",
      :revision => "2940084503a48359b41de178874e862c5bc3efe8"
    end

    go_resource "collectd.org" do
      url "https://github.com/collectd/go-collectd.git",
      :revision => "9fc824c70f713ea0f058a07b49a4c563ef2a3b98"
    end

    go_resource "github.com/paulbellamy/ratecounter" do
      url "https://github.com/paulbellamy/ratecounter.git",
      :revision => "5a11f585a31379765c190c033b6ad39956584447"
    end

    go_resource "github.com/shurcooL/github_flavored_markdown" do
      url "https://github.com/shurcooL/github_flavored_markdown.git",
      :revision => "b3921bea4a899100a4fd522dd940b819af56e437"
    end

    go_resource "github.com/shurcooL/gopherjslib" do
      url "https://github.com/shurcooL/gopherjslib.git",
      :revision => "f855ed7bcd82b53f720f6bf4a0c9b562e89276f6"
    end

    go_resource "golang.org/x/net" do
      url "https://go.googlesource.com/net.git",
      :revision => "7c71ca708c71bcbd0e6c856b01468ee07fe24557"
    end

    go_resource "github.com/gopherjs/gopherjs" do
      url "https://github.com/gopherjs/gopherjs.git",
      :revision => "ad712376c7b3218a7278e98928593a9959993a74"
    end

    go_resource "honnef.co/go/js/dom" do
      url "https://github.com/dominikh/go-js-dom.git",
      :revision => "24aa052bc5c63cfb9383bf59493ee48621ca788c"
    end

    go_resource "golang.org/x/tools" do
      url "https://go.googlesource.com/tools.git",
      :revision => "a2a552218a0e22e6fb22469f49ef371b492f6178"
    end

    go_resource "gopkg.in/pipe.v2" do
      url "https://gopkg.in/pipe.v2.git",
      :revision => "3c2ca4d525447ec8b2f606a6974f9c9f40831f26"
    end

    go_resource "github.com/shurcooL/httpfs" do
      url "https://github.com/shurcooL/httpfs.git",
      :revision => "f4a60bdbdd5a8f203c1ad5b6c95232f346eae1f5"
    end

    go_resource "github.com/microcosm-cc/bluemonday" do
      url "https://github.com/microcosm-cc/bluemonday.git",
      :revision => "4ac6f27528d0a3f2a59e0b0a6f6b3ff0bb89fe20"
    end

    go_resource "github.com/shurcooL/highlight_diff" do
      url "https://github.com/shurcooL/highlight_diff.git",
      :revision => "d2b0c68f5806a510c01992ecd0ca0e362eea8d56"
    end

    go_resource "github.com/shurcooL/highlight_go" do
      url "https://github.com/shurcooL/highlight_go.git",
      :revision => "1957344892ab030408ce1c7e0f93d56fb5ca1120"
    end

    go_resource "github.com/sourcegraph/annotate" do
      url "https://github.com/sourcegraph/annotate.git",
      :revision => "f4cad6c6324d3f584e1743d8b3e0e017a5f3a636"
    end

    go_resource "github.com/sourcegraph/syntaxhighlight" do
      url "https://github.com/sourcegraph/syntaxhighlight.git",
      :revision => "637a8b8b94eca8bb8cd559b950cc4f42629ec137"
    end

    go_resource "github.com/fsnotify/fsnotify" do
      url "https://github.com/fsnotify/fsnotify.git",
      :revision => "30411dbcefb7a1da7e84f75530ad3abe4011b4f8"
    end

    go_resource "github.com/kardianos/osext" do
      url "https://github.com/kardianos/osext.git",
      :revision => "29ae4ffbc9a6fe9fb2bc5029050ce6996ea1d3bc"
    end

    go_resource "github.com/neelance/sourcemap" do
      url "https://github.com/neelance/sourcemap.git",
      :revision => "8c68805598ab8d5637b1a72b5f7d381ea0f39c31"
    end

    go_resource "github.com/sergi/go-diff" do
      url "https://github.com/sergi/go-diff.git",
      :revision => "ec7fdbb58eb3e300c8595ad5ac74a5aa50019cc7"
    end

    go_resource "golang.org/x/sys" do
      url "https://go.googlesource.com/sys.git",
      :revision => "62bee037599929a6e9146f29d10dd5208c43507d"
    end
  end

  depends_on "go" => :build

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
    :revision => "bbd5bb678321a0d6e58f1099321dfa73391c1b6f"
  end

  go_resource "github.com/boltdb/bolt" do
    url "https://github.com/boltdb/bolt.git",
    :revision => "144418e1475d8bf7abbdc48583500f1a20c62ea7"
  end

  go_resource "github.com/cenkalti/backoff" do
    url "https://github.com/cenkalti/backoff.git",
    :revision => "32cd0c5b3aef12c76ed64aaf678f6c79736be7dc"
  end

  go_resource "github.com/dustin/go-humanize" do
    url "https://github.com/dustin/go-humanize.git",
    :revision => "8929fe90cee4b2cb9deb468b51fb34eba64d1bf0"
  end

  go_resource "github.com/gogo/protobuf" do
    url "https://github.com/gogo/protobuf.git",
    :revision => "4365f750fe246471f2a03ef5da5231c3565c5628"
  end

  go_resource "github.com/gorhill/cronexpr" do
    url "https://github.com/gorhill/cronexpr.git",
    :revision => "f0984319b44273e83de132089ae42b1810f4933b"
  end

  go_resource "github.com/influxdata/influxdb" do
    url "https://github.com/influxdata/influxdb.git",
    :revision => "f232c0548611371929e8a2cc082e29ae2d4a4326"
  end

  go_resource "github.com/influxdb/usage-client" do
    url "https://github.com/influxdb/usage-client.git",
    :revision => "475977e68d79883d9c8d67131c84e4241523f452"
  end

  go_resource "github.com/kimor79/gollectd" do
    url "https://github.com/kimor79/gollectd.git",
    :revision => "b5dddb1667dcc1e6355b9305e2c1608a2db6983c"
  end

  go_resource "github.com/mattn/go-runewidth" do
    url "https://github.com/mattn/go-runewidth.git",
    :revision => "d6bea18f789704b5f83375793155289da36a3c7f"
  end

  go_resource "github.com/naoina/go-stringutil" do
    url "https://github.com/naoina/go-stringutil.git",
    :revision => "6b638e95a32d0c1131db0e7fe83775cbea4a0d0b"
  end

  go_resource "github.com/naoina/toml" do
    url "https://github.com/naoina/toml.git",
    :revision => "751171607256bb66e64c9f0220c00662420c38e9"
  end

  go_resource "github.com/russross/blackfriday" do
    url "https://github.com/russross/blackfriday.git",
    :revision => "b43df972fb5fdf3af8d2e90f38a69d374fe26dd0"
  end

  go_resource "github.com/serenize/snaker" do
    url "https://github.com/serenize/snaker.git",
    :revision => "8824b61eca66d308fcb2d515287d3d7a28dba8d6"
  end

  go_resource "github.com/shurcooL/go" do
    url "https://github.com/shurcooL/go.git",
    :revision => "377921096a5b956ff0a2cd207bf03a385a3af745"
  end

  go_resource "github.com/shurcooL/markdownfmt" do
    url "https://github.com/shurcooL/markdownfmt.git",
    :revision => "45e6ea2c4705675a93a32b5f548dbb7997826875"
  end

  go_resource "github.com/shurcooL/sanitized_anchor_name" do
    url "https://github.com/shurcooL/sanitized_anchor_name.git",
    :revision => "10ef21a441db47d8b13ebcc5fd2310f636973c77"
  end

  go_resource "github.com/stretchr/testify" do
    url "https://github.com/stretchr/testify.git",
    :revision => "1f4a1643a57e798696635ea4c126e9127adb7d3c"
  end

  go_resource "github.com/twinj/uuid" do
    url "https://github.com/twinj/uuid.git",
    :revision => "89173bcdda19db0eb88aef1e1cb1cb2505561d31"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
    :revision => "b8a0f4bb4040f8d884435cff35b9691e362cf00c"
  end

  go_resource "gopkg.in/gomail.v2" do
    url "https://gopkg.in/gomail.v2.git",
    :revision => "42916101524810bd3aed9a8b25e6bb58d8e3af82"
  end

  def install
    ENV["GOPATH"] = buildpath
    kapacitor_path = buildpath/"src/github.com/influxdata/kapacitor"
    kapacitor_path.install Dir["*"]
    revision = `git rev-parse HEAD`.strip
    version = `git describe --tags`.strip

    Language::Go.stage_deps resources, buildpath/"src"

    cd kapacitor_path do
      system "go", "install",
             "-ldflags", "-X main.version=#{version} -X main.commit=#{revision}",
             "./..."
    end

    inreplace kapacitor_path/"etc/kapacitor/kapacitor.conf" do |s|
      s.gsub! "/var/lib/kapacitor", "#{var}/kapacitor"
      s.gsub! "/var/log/kapacitor", "#{var}/log"
    end

    bin.install "bin/kapacitord"
    bin.install "bin/kapacitor"
    etc.install kapacitor_path/"etc/kapacitor/kapacitor.conf" => "kapacitor.conf"

    (var/"kapacitor/replay").mkpath
    (var/"kapacitor/tasks").mkpath
  end

  plist_options :manual => "kapacitord -config #{HOMEBREW_PREFIX}/etc/kapacitor.conf"

  def plist; <<-EOS.undent
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
          <string>#{opt_bin}/kapacitord</string>
          <string>-config</string>
          <string>#{HOMEBREW_PREFIX}/etc/kapacitor.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/kapacitor.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/kapacitor.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    (testpath/"config.toml").write shell_output("kapacitord config")

    inreplace testpath/"config.toml" do |s|
      s.gsub! /disable-subscriptions = false/, "disable-subscriptions = true"
      s.gsub! %r{data_dir = "/.*/.kapacitor"}, "data_dir = \"#{testpath}/kapacitor\""
      s.gsub! %r{/.*/.kapacitor/replay}, "#{testpath}/kapacitor/replay"
      s.gsub! %r{/.*/.kapacitor/tasks}, "#{testpath}/kapacitor/tasks"
      s.gsub! %r{/.*/.kapacitor/kapacitor.db}, "#{testpath}/kapacitor/kapacitor.db"
    end

    begin
      pid = fork do
        exec "#{bin}/kapacitord", "-config", "#{testpath}/config.toml"
      end
      sleep 1
      shell_output("#{bin}/kapacitor list tasks")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
