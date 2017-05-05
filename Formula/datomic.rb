class Datomic < Formula
  desc "Database separating transactions, storage and queries"
  homepage "http://www.datomic.com/"
  url "https://my.datomic.com/downloads/free/0.9.5561"
  sha256 "50f67065f9ca43ab71d27b60fa68d3aae7d818095accc76bdfbb529fba1fac90"

  bottle :unneeded

  depends_on :java

  def install
    libexec.install Dir["*"]
    (bin/"datomic").write_env_script libexec/"bin/datomic", Language::Java.java_home_env

    %w[transactor repl repl-jline rest shell groovysh maven-install].each do |file|
      (bin/"datomic-#{file}").write_env_script libexec/"bin/#{file}", Language::Java.java_home_env
    end

    # create directory for datomic data and logs
    (var/"lib/datomic").mkpath

    # install free-transactor properties
    data = var/"lib/datomic"
    (etc/"datomic").mkpath
    (etc/"datomic").install libexec/"config/samples/free-transactor-template.properties" => "free-transactor.properties"

    inreplace "#{etc}/datomic/free-transactor.properties" do |s|
      s.gsub! "# data-dir=data", "data-dir=#{data}/"
      s.gsub! "# log-dir=log", "log-dir=#{data}/log"
    end
  end

  def post_install
    # create directory for datomic stdout+stderr output logs
    (var/"log/datomic").mkpath
  end

  def caveats
    <<-EOS.undent
      All commands have been installed with the prefix "datomic-".

      We agreed to the Datomic Free Edition License for you:
        http://www.datomic.com/datomic-free-edition-license.html
      If this is unacceptable you should uninstall.
    EOS
  end

  plist_options :manual => "transactor #{HOMEBREW_PREFIX}/etc/datomic/free-transactor.properties"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/datomic-transactor</string>
            <string>#{etc}/datomic/free-transactor.properties</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>StandardErrorPath</key>
        <string>#{var}/log/datomic/error.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/datomic/output.log</string>
    </dict>
    </plist>
    EOS
  end

  test do
    IO.popen("#{bin}/datomic-repl", "r+") do |pipe|
      assert_equal "Clojure 1.9.0-alpha14", pipe.gets.chomp
      pipe.puts "^C"
      pipe.close_write
      pipe.close
    end
  end
end
