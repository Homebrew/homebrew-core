class Gemstash < Formula
  desc "RubyGems.org cache and private gem server"
  homepage "https://github.com/bundler/gemstash"
  url "https://rubygems.org/downloads/gemstash-2.0.0.gem"
  sha256 "511a5773c43507b913c4f2f57d33a3d972bd71378b2669c22a357b3351a82bf4"
  head "https://github.com/bundler/gemstash.git"

  if MacOS.version < :mojave
    depends_on "openssl"
    depends_on "ruby"
  end

  def install
    if build.head?
      system "gem", "build", "gemstash.gemspec"
      gem_file = Dir["*.gem"].first
    else
      gem_file = "gemstash-#{version}.gem"
    end

    ENV["GEM_HOME"] = libexec

    if MacOS.version < :mojave
      gem = Formula["ruby"].bin/"gem"
    else
      gem = "gem"
    end

    system gem, "install", "--no-document", gem_file

    (bin/"gemstash").write_env_script libexec/"bin/gemstash",
      :GEM_HOME                      => ENV["GEM_HOME"],
      :SINATRA_ACTIVESUPPORT_WARNING => false

    (var/"gemstash").mkpath
    (etc/"gemstash").mkpath
    config_file.write <<~EOS
      ---
      :base_path: "#{var}/gemstash"
      :bind: tcp://127.0.0.1:#{port}
      :cache_type: memory
      :db_adapter: sqlite3
      :protected_fetch: false
      :fetch_timeout: 20
    EOS
  end

  def caveats; <<~EOS
    With the server running, you can bundle install against it. Tell Bundler
    that you want to use gemstash to find gems from rubygems.org:

        $ bundle config mirror.https://rubygems.org http://localhost:#{port}

    The configuration file can be found at #{config_file}.
  EOS
  end

  plist_options :manual => "gemstash"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
            <string>#{bin}/gemstash</string>
            <string>start</string>
            <string>--no-daemonize</string>
            <string>--config-file</string>
            <string>#{config_file}</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/gemstash.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/gemstash.log</string>
      </dict>
    </plist>
  EOS
  end

  test do
    require "pty"

    ohai "Starting gemstash"

    PTY.spawn("#{bin}/gemstash start --no-daemonize") do |r, _, pid|
      begin
        loop do
          available = IO.select([r], [], [], 15)
          assert_not_equal available, nil

          line = r.readline.strip

          if line.include?("Starting gemstash!")
            ohai "Server is up (pid=#{pid})"
            break
          end
        end
      ensure
        Process.kill("SIGINT", pid)
        ohai "Shuting down"
      end
    end
  end

  private

  def port
    29292
  end

  def config_file
    etc/"gemstash/config.yml"
  end
end
