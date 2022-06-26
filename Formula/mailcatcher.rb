class Mailcatcher < Formula
  desc "Catches mail and serves it through a dream"
  homepage "https://mailcatcher.me"
  url "https://github.com/sj26/mailcatcher/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "3bf200ab3b2926d3747a462afd68dce5a28a11fe8d2834ce929c99c90d4192d3"
  license "MIT"

  bottle do
    sha256                               arm64_monterey: "3be13e4d6da19162bc7d70f201185fdb3f7dcd1b6207d632df446a3adc9b27dc"
    sha256                               arm64_big_sur:  "f1a3d77e3f95325952f78a408eba5e08b125b962f47a12265afd80489458f077"
    sha256                               monterey:       "d33f530eef6e1f7455c7d2dd36fcf75472a709f76118da99d82d207034b6f484"
    sha256                               big_sur:        "4f8ffd6afc2180fb12b59fda6ff9346ff2bbf6e6e10e685286cb161f706179b6"
    sha256                               catalina:       "5bb1102c3a30c01a72f6b6a44ef0d19c35f434b32960cce7b2a3aa19c4ccbf20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c27e2ce76bc1ea4b0d32f40e36a429eaf375a2dd7bc8bcc1e0a80240589720ee"
  end

  depends_on "pkg-config" => :build

  uses_from_macos "curl" => :test
  uses_from_macos "expect" => :test
  uses_from_macos "netcat" => :test
  uses_from_macos "libffi"
  uses_from_macos "ruby"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "node" => :build
  end

  resource "bundler" do
    url "https://rubygems.org/downloads/bundler-2.2.25.gem"
    sha256 "422237ffbbf2ceb05e696df7abb1bd1a82b5b1823eb2aeb6193312a60c319d8d"
  end

  resource "eventmachine" do
    url "https://rubygems.org/downloads/eventmachine-1.0.9.1.gem"
    sha256 "9f4cb30b3bce0c2a90da875a81534f12cbf6f1174f80d64c32efbda1140b599e"
  end

  resource "mini_mime" do
    url "https://rubygems.org/downloads/mini_mime-1.1.0.gem"
    sha256 "30f2cca8a3c62b5c067f73a1834479dbd85d71f1291d65ffac933dc90796674d"
  end

  resource "mail" do
    url "https://rubygems.org/downloads/mail-2.7.1.gem"
    sha256 "ec2a3d489f7510b90d8eaa3f6abaad7038cf1d663cdf8ee66d0214a0bdf99c03"
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
    url "https://rubygems.org/downloads/tilt-2.0.10.gem"
    sha256 "9b664f0e9ae2b500cfa00f9c65c34abc6ff1799cf0034a8c0a0412d520fac866"
  end

  resource "sinatra" do
    url "https://rubygems.org/downloads/sinatra-1.4.8.gem"
    sha256 "18cb20ffabf31484b02d8606e450fbf040b52aea6147755a07718e9e0ffddd2f"
  end

  resource "daemons" do
    url "https://rubygems.org/downloads/daemons-1.4.0.gem"
    sha256 "c3fdae2a6309cef75fb98c9a39938fac058ac19cbe08dfd1a3d8297ca30a71ba"
  end

  resource "thin" do
    url "https://rubygems.org/downloads/thin-1.5.1.gem"
    sha256 "ea85c4c7d5b1bd29c4992757ccf8be0ddee9d4030f428db347f59a05474d3843"
  end

  resource "skinny" do
    url "https://rubygems.org/downloads/skinny-0.2.4.gem"
    sha256 "498d447cc99f638470b87fc5814bc82cd799cb9453f3a04523ff518f50df7ef8"
  end

  resource "sqlite" do
    url "https://rubygems.org/downloads/sqlite3-1.4.2.gem"
    sha256 "e8b8ef3b0f75c18e1a7ee62c5678c827e99389e53fa55eb7a9a5f57459004a52"
  end

  def install
    if MacOS.version >= :mojave && MacOS::CLT.installed?
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
                ENV.compiler == :clang ? "--with-cflags=-fdeclspec" : ""
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
  end

  service do
    run [opt_bin/"mailcatcher", "-f"]
    log_path var/"log/mailcatcher.log"
    error_log_path var/"log/mailcatcher.log"
    keep_alive true
  end

  test do
    system "mailcatcher"
    (testpath/"mailcatcher.exp").write <<~EOS
      #! /usr/bin/env expect

      set timeout 1
      spawn nc -c localhost 1025

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
    assert_match "bob@example.org", shell_output("curl --silent http://localhost:1080/messages")
    assert_equal "Hello Alice.", shell_output("curl --silent http://localhost:1080/messages/1.plain").strip
    system "curl", "--silent", "-X", "DELETE", "http://localhost:1080/"
  end
end
