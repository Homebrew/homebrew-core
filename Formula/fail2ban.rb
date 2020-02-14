class Fail2ban < Formula
  desc "Scan log files and ban IPs showing malicious signs"
  homepage "https://www.fail2ban.org/"
  url "https://github.com/fail2ban/fail2ban/archive/0.11.1.tar.gz"
  sha256 "71d2a52b66bb0f87ac3812246bdd3819ec561913cd44afd39130a342f043aa6d"

  bottle do
    cellar :any_skip_relocation
    sha256 "f2605d6a90684a723f5ac164483846d5a97e9b17ec5a8e3e39c34fe7e544275a" => :catalina
    sha256 "bde88951f2011891000bfb6cba6035d1ec65e021633baf2296c3aaa00260a943" => :mojave
    sha256 "e80aa92198a8c6144bfda9a286a54a20b5b5c377e6f082120da33d0f9cf9bb35" => :high_sierra
  end

  depends_on "help2man" => :build
  depends_on "sphinx-doc" => :build
  depends_on "python@3.8"

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python3.8/site-packages"
    ENV["PYTHON"] = Formula["python@3.8"].opt_bin/"python3"

    rm "setup.cfg"
    Dir["config/paths-*.conf"].each do |r|
      next if /paths-common\.conf|paths-osx\.conf/.match?(File.basename(r))

      rm r
    end

    # Replace paths in config
    inreplace "config/jail.conf", "before = paths-debian.conf", "before = paths-osx.conf"

    # Replace hardcoded paths
    inreplace "setup.py" do |s|
      s.gsub! %r{/etc}, etc
      s.gsub! %r{/var}, var
    end

    inreplace Dir["config/{action,filter}.d/**/*"].select { |ff| File.file?(ff) }.each do |s|
      s.gsub! %r{/etc}, etc, false
      s.gsub! %r{/var}, var, false
    end

    inreplace ["config/fail2ban.conf", "config/paths-common.conf", "doc/run-rootless.txt"].each do |s|
      s.gsub! %r{/etc}, etc
      s.gsub! %r{/var}, var
    end

    inreplace Dir["fail2ban/client/*"].each do |s|
      s.gsub! %r{/etc}, etc, false
      s.gsub! %r{/var}, var, false
    end

    inreplace "fail2ban/server/asyncserver.py", "/var/run/fail2ban/fail2ban.sock",
              var/"run/fail2ban/fail2ban.sock"

    inreplace Dir["fail2ban/tests/**/*"].select { |ff| File.file?(ff) }.each do |s|
      s.gsub! %r{/etc}, etc, false
      s.gsub! %r{/var}, var, false
    end

    inreplace Dir["man/*"].each do |s|
      s.gsub! %r{/etc}, etc, false
      s.gsub! %r{/var}, var, false
    end

    # Fix doc compilation
    inreplace "setup.py", "/usr/share/doc/fail2ban", (share/"doc")
    inreplace "setup.py", "if os.path.exists('#{var}/run')", "if True"
    inreplace "setup.py", "platform_system in ('linux',", "platform_system in ('linux', 'darwin',"

    system "python3", "setup.py", "install", "--prefix=#{libexec}"

    cd "doc" do
      system "make", "dirhtml", "SPHINXBUILD=sphinx-build"
      (share/"doc").install "build/dirhtml"
    end

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    man1.install Dir["man/*.1"]
    man5.install "man/jail.conf.5"
  end

  def post_install
    (etc/"fail2ban").mkpath
    (var/"run/fail2ban").mkpath
  end

  def caveats
    <<~EOS
      Before using Fail2Ban for the first time you should edit the jail
      configuration and enable the jails that you want to use, for instance
      ssh-ipfw. Also, make sure that they point to the correct configuration
      path. I.e. on Mountain Lion the sshd logfile should point to
      /var/log/system.log.

        * #{etc}/fail2ban/jail.conf

      The Fail2Ban wiki has two pages with instructions for macOS Server that
      describes how to set up the Jails for the standard macOS Server
      services for the respective releases.

        10.4: https://www.fail2ban.org/wiki/index.php/HOWTO_Mac_OS_X_Server_(10.4)
        10.5: https://www.fail2ban.org/wiki/index.php/HOWTO_Mac_OS_X_Server_(10.5)

      Please do not forget to update your configuration files.
      They are in #{etc}/fail2ban.
    EOS
  end

  plist_options :startup => true

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
          <string>#{opt_bin}/fail2ban-client</string>
          <string>-x</string>
          <string>start</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
      </plist>
    EOS
  end

  test do
    system "#{bin}/fail2ban-client", "--test"
  end
end
