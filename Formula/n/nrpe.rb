class Nrpe < Formula
  desc "Nagios remote plugin executor"
  homepage "https://www.nagios.org/"
  url "https://github.com/NagiosEnterprises/nrpe/releases/download/nrpe-4.2.0/nrpe-4.2.0.tar.gz"
  sha256 "0d1eac6845d360b200b037f2b8c0199f1acbe3bea36ad72236ad619e5447e555"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "53a9deab35083b2965d61f1984df70dd46f845bad0fec3b9d7758d7b69ac6fa0"
    sha256 cellar: :any, arm64_tahoe:       "573e537c720f51d9d7bc3c35100c0f89366369199194aab434bdace272f1486f"
    sha256 cellar: :any, arm64_sequoia:     "039145ca0194d851d6f147b2b0538be03ffaee183772b2745cd4981556e387ed"
    sha256 cellar: :any, arm64_linux:       "618dfa1d26af8f485dd1b4857d87d9651361037d4f04c1e226dd597986c149cb"
    sha256 cellar: :any, x86_64_linux:      "70511e5e7cb13df75c8c1b6eb475739c35c8723696d7c639d38c6ef5f2dba4d8"
  end

  depends_on "nagios-plugins"
  depends_on "openssl@3"

  allow_network_access! :test

  def install
    user  = `id -un`.chomp
    group = `id -gn`.chomp

    if OS.linux?
      ENV["tmpfilesd"] = etc/"tmpfiles.d"
      (etc/"tmpfiles.d").mkpath
    end

    system "./configure", "--prefix=#{prefix}",
                          "--libexecdir=#{HOMEBREW_PREFIX}/sbin",
                          "--with-piddir=#{var}/run",
                          "--sysconfdir=#{etc}",
                          "--with-nrpe-user=#{user}",
                          "--with-nrpe-group=#{group}",
                          "--with-nagios-user=#{user}",
                          "--with-nagios-group=#{group}",
                          "--with-ssl=#{formula_opt_prefix("openssl@3")}",
                          # Set both or it still looks for /usr/lib
                          "--with-ssl-lib=#{formula_opt_lib("openssl@3")}",
                          "--enable-ssl",
                          "--enable-command-args"

    inreplace "src/Makefile" do |s|
      s.gsub! "$(LIBEXECDIR)", "$(SBINDIR)"
      s.gsub! "$(DESTDIR)#{HOMEBREW_PREFIX}/sbin", "$(SBINDIR)"
    end

    system "make", "all"
    system "make", "install", "install-config"

    (var/"run").mkpath
  end

  service do
    run [opt_bin/"nrpe", "-c", etc/"nrpe.cfg", "-d"]
  end

  def port_open?(ip_address, port, seconds = 1)
    Timeout.timeout(seconds) do
      TCPSocket.new(ip_address, port).close
    end
    true
  rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Timeout::Error
    false
  end

  test do
    port = free_port
    cp etc/"nrpe.cfg", testpath
    inreplace "nrpe.cfg", /^server_port=5666$/, "server_port=#{port}"

    pid = spawn bin/"nrpe", "-n", "-c", testpath/"nrpe.cfg", "-d"
    sleep 2

    begin
      assert port_open?("localhost", port), "nrpe did not start"
      pid_nrpe = shell_output("pgrep nrpe").to_i
    ensure
      Process.kill("SIGINT", pid_nrpe) if pid_nrpe
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
