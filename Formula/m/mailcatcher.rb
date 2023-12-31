class Mailcatcher < Formula
  desc "Catches mail and serves it through a dream"
  homepage "https://mailcatcher.me"
  url "https://github.com/sj26/mailcatcher/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "6f6651035bf09357ca50cccf2ce4874e30e56563006219b8bf7b663e12ccaecf"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "24d088adafb5277c5a550836dc32009bcf320de229ec44f3f5a8cab573436135"
    sha256                               arm64_ventura:  "6c04fd2473fc24df836d8dcdab4a7534f4366ec5c5648b7b98462ec9de74d96f"
    sha256                               arm64_monterey: "6aeff71ae28206fe39800ec8f7233a6ab39c7130688f97e3c2115bae0df5aad6"
    sha256                               arm64_big_sur:  "825e9ac8678b8eb0e879a864fa48653ff65351eaab8ed3c816ee568dc5e7cc25"
    sha256                               sonoma:         "46351e4e2e1418b493818975a832e42733337cb747f9fef1133cfb9b89efea29"
    sha256                               ventura:        "9ef40b473248d0eb34206d131b135c64331c6d96d7039e99b23413b862ad89de"
    sha256                               monterey:       "f3a391805115ae9a3dfcaabb63d59eb4bf4c4d24b78b8ffb5deddcf1a2315d11"
    sha256                               big_sur:        "23804ac86d1dcf62f0726c656f121ac320b93a5b865267562063d2cf9afed6db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ee0bf63eb25796d9868ed5d3e0c7c07b1218e0554f406e5802d1b9de3c69625"
  end

  depends_on "pkg-config" => :build
  depends_on "libyaml"

  uses_from_macos "xz" => :build
  uses_from_macos "curl" => :test
  uses_from_macos "expect" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "libffi"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "node" => :build
    depends_on "ruby"
  end

  resource "bundler" do
    url "https://rubygems.org/downloads/bundler-2.4.17.gem"
    sha256 "d8457a5e76c9d153d4bb0fd1ffd2a3f58fbf090cb3448b9bd7a021d13f0e44ad"
  end

  resource "eventmachine" do
    url "https://rubygems.org/downloads/eventmachine-1.0.9.1.gem"
    sha256 "9f4cb30b3bce0c2a90da875a81534f12cbf6f1174f80d64c32efbda1140b599e"
  end

  resource "websocket-extensions" do
    url "https://rubygems.org/downloads/websocket-extensions-0.1.5.gem"
    sha256 "1c6ba63092cda343eb53fc657110c71c754c56484aad42578495227d717a8241"
  end

  resource "websocket-driver" do
    url "https://rubygems.org/downloads/websocket-driver-0.7.6.gem"
    sha256 "f69400be7bc197879726ad8e6f5869a61823147372fd8928836a53c2c741d0db"
  end

  resource "faye-websocket" do
    url "https://rubygems.org/downloads/faye-websocket-0.11.3.gem"
    sha256 "109187161939c57032d2bba9e5c45621251d73f806bb608d2d4c3ab2cabeb307"
  end

  resource "mini_mime" do
    url "https://rubygems.org/downloads/mini_mime-1.1.2.gem"
    sha256 "a54aec0cc7438a03a850adb00daca2bdb60747f839e28186994df057cea87151"
  end

  resource "date" do
    url "https://rubygems.org/downloads/date-3.3.3.gem"
    sha256 "819792019d5712b748fb15f6dfaaedef14b0328723ef23583ea35f186774530f"
  end

  resource "timeout" do
    url "https://rubygems.org/downloads/timeout-0.4.0.gem"
    sha256 "cd6d1f3e83594a90ac1f3de8235399bff87112d97fec928ee2b77de240dd2cb5"
  end

  resource "net-protocol" do
    url "https://rubygems.org/downloads/net-protocol-0.2.1.gem"
    sha256 "21adb19c197768899c389bd257545de9d5af64adb1928787653460c2699eac37"
  end

  resource "net-imap" do
    url "https://rubygems.org/downloads/net-imap-0.3.7.gem"
    sha256 "231fc961974fe32c59a019893ae0849d55792412b65a8d43910a7e761ee6c751"
  end

  resource "net-pop" do
    url "https://rubygems.org/downloads/net-pop-0.1.2.gem"
    sha256 "848b4e982013c15b2f0382792268763b748cce91c9e91e36b0f27ed26420dff3"
  end

  resource "net-smtp" do
    url "https://rubygems.org/downloads/net-smtp-0.3.3.gem"
    sha256 "3d51dcaa981b74aff2d89cbe89de4503bc2d682365ea5176366e950a0d68d5b0"
  end

  resource "mail" do
    url "https://rubygems.org/downloads/mail-2.8.1.gem"
    sha256 "ec3b9fadcf2b3755c78785cb17bc9a0ca9ee9857108a64b6f5cfc9c0b5bfc9ad"
  end

  resource "ruby2_keywords" do
    url "https://rubygems.org/downloads/ruby2_keywords-0.0.5.gem"
    sha256 "ffd13740c573b7301cf7a2e61fc857b2a8e3d3aff32545d6f8300d8bae10e3ef"
  end

  resource "mustermann" do
    url "https://rubygems.org/downloads/mustermann-3.0.0.gem"
    sha256 "6d3569aa3c3b2f048c60626f48d9b2d561cc8d2ef269296943b03da181c08b67"
  end

  resource "rack" do
    url "https://rubygems.org/downloads/rack-1.6.13.gem"
    sha256 "207e60f917a7b47cb858a6e813500bc6042a958c2ca9eeb64631b19cde702173"
  end

  resource "rack-protection" do
    url "https://rubygems.org/downloads/rack-protection-1.5.5.gem"
    sha256 "5a9f0d56ef96b616a242138986dc930aca76f6efa24f998e8683164538e5c057"
  end

  resource "tilt" do
    url "https://rubygems.org/downloads/tilt-2.2.0.gem"
    sha256 "e76f850e611128a87992bb13ba74807624a9b8ec748e2c2ea7139580f67ab22e"
  end

  resource "sinatra" do
    url "https://rubygems.org/downloads/sinatra-1.4.8.gem"
    sha256 "18cb20ffabf31484b02d8606e450fbf040b52aea6147755a07718e9e0ffddd2f"
  end

  resource "mini_portile2" do
    url "https://rubygems.org/downloads/mini_portile2-2.8.4.gem"
    sha256 "180bc4193701bbeb9b6c02df5a6b8185bff7f32abd466dd97d6532d36e45b20a"
  end

  resource "sqlite" do
    url "https://rubygems.org/downloads/sqlite3-1.6.3.gem"
    sha256 "67b476378889b15c93f9b78d39f6d92636dda414194d570d3a1b27514a9e2541"
  end

  resource "daemons" do
    url "https://rubygems.org/downloads/daemons-1.4.1.gem"
    sha256 "8fc76d76faec669feb5e455d72f35bd4c46dc6735e28c420afb822fac1fa9a1d"
  end

  resource "thin" do
    url "https://rubygems.org/downloads/thin-1.8.2.gem"
    sha256 "1c55251aba5bee7cf6936ea18b048f4d3c74ef810aa5e6906cf6edff0df6e121"
  end

  def install
    if OS.mac? && MacOS.version >= :mojave && MacOS::CLT.installed?
      ENV["SDKROOT"] = ENV["HOMEBREW_SDKROOT"] = MacOS::CLT.sdk_path(MacOS.version)
    end

    ENV["GEM_HOME"] = buildpath/"gem_home"
    system "gem", "install", "--no-document", resource("bundler").cached_download
    with_env(PATH: "#{buildpath}/gem_home/bin:#{ENV["PATH"]}") do
      system "bundle", "config", "build.thin", "--with-cflags=-Wno-implicit-function-declaration"
      system "bundle", "config", "build.sqlite3", "--with-cflags=-fdeclspec" if ENV.compiler == :clang
      system "bundle", "install"
      system "bundle", "exec", "rake", "assets"
    end

    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      # Per https://github.com/sj26/mailcatcher/issues/452
      case r.name
      when "thin"
        system "gem", "install", r.cached_download, "--ignore-dependencies",
                "--no-document", "--install-dir", libexec, "--",
                "--with-cflags=-Wno-implicit-function-declaration"
      when "sqlite"
        system "gem", "install", r.cached_download, "--ignore-dependencies",
                "--no-document", "--install-dir", libexec, "--",
                (ENV.compiler == :clang) ? "--with-cflags=-fdeclspec" : ""
      when "bundler"
        # bundler is needed only at build-time
      else
        system "gem", "install", r.cached_download, "--ignore-dependencies",
                "--no-document", "--install-dir", libexec
      end
    end

    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "--ignore-dependencies", "#{name}-#{version}.gem"
    bin.install libexec/"bin"/name, libexec/"bin/catchmail"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])

    # Remove temporary logs that reference Homebrew shims.
    # TODO: See if we can handle this better:
    #       https://github.com/sparklemotion/sqlite3-ruby/discussions/394
    rm_rf libexec/"gems/sqlite3-#{resource("sqlite").version}/ext/sqlite3/tmp"
  end

  service do
    run [opt_bin/"mailcatcher", "-f"]
    log_path var/"log/mailcatcher.log"
    error_log_path var/"log/mailcatcher.log"
    keep_alive true
  end

  test do
    smtp_port = free_port
    http_port = free_port
    system bin/"mailcatcher", "--smtp-port", smtp_port.to_s, "--http-port", http_port.to_s
    (testpath/"mailcatcher.exp").write <<~EOS
      #! /usr/bin/env expect

      set timeout 1
      spawn nc -c localhost #{smtp_port}

      expect {
        "220 *" { send -- "HELO example.org\n" }
        timeout { exit 1 }
      }

      expect {
        "250 *" { send -- "MAIL FROM:<bob@example.org>\n" }
        timeout { exit 1 }
      }

      expect {
        "250 *" { send -- "RCPT TO:<alice@example.com>\n" }
        timeout { exit 1 }
      }

      expect {
        "250 *" { send -- "DATA\n" }
        timeout { exit 1 }
      }

      expect {
        "354 *" {
          send -- "From: Bob Example <bob@example.org>\n"
          send -- "To: Alice Example <alice@example.com>\n"
          send -- "Date: Tue, 15 Jan 2008 16:02:43 -0500\n"
          send -- "Subject: Test message\n"
          send -- "\n"
          send -- "Hello Alice.\n"
          send -- ".\n"
        }
        timeout { exit 1 }
      }


      expect {
        "250 *" {
          send -- "QUIT\n"
        }
        timeout { exit 1 }
      }

      expect {
        "221 *" { }
        eof { exit }
      }
    EOS

    system "expect", "-f", "mailcatcher.exp"
    assert_match "bob@example.org", shell_output("curl --silent http://localhost:#{http_port}/messages")
    assert_equal "Hello Alice.", shell_output("curl --silent http://localhost:#{http_port}/messages/1.plain").strip
    system "curl", "--silent", "-X", "DELETE", "http://localhost:#{http_port}/"
  end
end
