class Piknik < Formula
  desc "Copy/paste anything over the network"
  homepage "https://github.com/jedisct1/piknik"
  url "https://github.com/jedisct1/piknik/archive/0.9.1.tar.gz"
  sha256 "a682e16d937a5487eda5b0d0889ae114e228bd3c9beddd743cad40f1bad94448"
  head "https://github.com/jedisct1/piknik.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4c8bce52891ea6547f5644108b72300405c27e84e539fde0fa60c25e69db7a8e" => :catalina
    sha256 "eee56739c24346b50d4fb7afa1285c87fbea135f3acd5fa90d1c2b9a81f84284" => :mojave
    sha256 "1209dc34580813c42b1075174e9f78e049f43449845c63aa3f033e761ecf0bd0" => :high_sierra
    sha256 "fffe6c2329ae0840061a464162703ec7cd26649cd985d1ff4de37315059b9357" => :sierra
    sha256 "40b1bdb322e89f3c955519a3156f8ab9ed7aa3833f0887f1bb1ccf6224038de8" => :el_capitan
    sha256 "c1bb1b4632aca54d93490f53b9142f7f808abec1cd6761418df63f11abeb80fe" => :yosemite
  end

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    dir = buildpath/"src/github.com/jedisct1/"
    dir.install Dir["*"]
    ln_s buildpath/"src", dir
    cd dir do
      system "glide", "install"
      system "go", "build", "-o", bin/"piknik", "."
      (prefix/"etc/profile.d").install "zsh.aliases" => "piknik.sh"
      prefix.install_metafiles
    end
  end

  def caveats
    <<~EOS
      In order to get convenient shell aliases, put something like this in #{shell_profile}:
        . #{etc}/profile.d/piknik.sh
    EOS
  end

  plist_options :manual => "piknik -server"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/piknik</string>
            <string>-server</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
        </dict>
      </plist>
    EOS
  end

  test do
    conffile = testpath/"testconfig.toml"

    genkeys = shell_output("#{bin}/piknik -genkeys")
    lines = genkeys.lines.grep(/\s+=\s+/).map { |x| x.gsub(/\s+/, " ").gsub(/#.*/, "") }.uniq
    conffile.write lines.join("\n")
    pid = fork do
      exec "#{bin}/piknik", "-server", "-config", conffile
    end
    begin
      sleep 1
      IO.popen([{}, "#{bin}/piknik", "-config", conffile, "-copy"], "w+") do |p|
        p.write "test"
      end
      IO.popen([{}, "#{bin}/piknik", "-config", conffile, "-move"], "r") do |p|
        clipboard = p.read
        assert_equal clipboard, "test"
      end
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
      conffile.unlink
    end
  end
end
