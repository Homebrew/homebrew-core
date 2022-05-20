class IscDhcp < Formula
  desc "Production-grade DHCP solution"
  homepage "https://www.isc.org/dhcp"
  url "https://ftp.isc.org/isc/dhcp/4.4.3/dhcp-4.4.3.tar.gz"
  sha256 "0e3ec6b4c2a05ec0148874bcd999a66d05518378d77421f607fb0bc9d0135818"
  license "MPL-2.0"

  livecheck do
    url "https://www.isc.org/download/"
    regex(%r{href=.*?/dhcp[._-]v?(\d+(?:\.\d+)+(?:-P\d+)?)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "f8cadbaf43f606d695fe9b54df4d2ce16fc733f277b79184b9dfb425dc36fe22"
    sha256 arm64_big_sur:  "fa545e13acdf113c1263f81982a7738e715df886792a6cb73780e2dad1478ea5"
    sha256 monterey:       "8e8f544a2b0b2563b5e73f09ef0e158f4c05bc658ade948d2523a724069dc5f7"
    sha256 big_sur:        "575a4286d3809339244093635bd660becb24701b3898d981f76f7c031450f54c"
    sha256 catalina:       "7d503b4a52efa04cb73015ccb8bef335b8732b14a9ecf8590add0e53ed7e87ea"
    sha256 x86_64_linux:   "b8aaea5afad5dbec95253adbb1b62ab74bbf9c6ca9357d7df14bcfcd97250357"
  end

  def install
    # use one dir under var for all runtime state.
    dhcpd_dir = var/"dhcpd"

    # Change the locations of various files to match Homebrew
    # we pass these in through CFLAGS since some cannot be changed
    # via configure args.
    path_opts = {
      "_PATH_DHCPD_CONF"    => etc/"dhcpd.conf",
      "_PATH_DHCLIENT_CONF" => etc/"dhclient.conf",
      "_PATH_DHCPD_DB"      => dhcpd_dir/"dhcpd.leases",
      "_PATH_DHCPD6_DB"     => dhcpd_dir/"dhcpd6.leases",
      "_PATH_DHCLIENT_DB"   => dhcpd_dir/"dhclient.leases",
      "_PATH_DHCLIENT6_DB"  => dhcpd_dir/"dhclient6.leases",
      "_PATH_DHCPD_PID"     => dhcpd_dir/"dhcpd.pid",
      "_PATH_DHCPD6_PID"    => dhcpd_dir/"dhcpd6.pid",
      "_PATH_DHCLIENT_PID"  => dhcpd_dir/"dhclient.pid",
      "_PATH_DHCLIENT6_PID" => dhcpd_dir/"dhclient6.pid",
      "_PATH_DHCRELAY_PID"  => dhcpd_dir/"dhcrelay.pid",
      "_PATH_DHCRELAY6_PID" => dhcpd_dir/"dhcrelay6.pid",
    }

    path_opts.each do |symbol, path|
      ENV.append "CFLAGS", "-D#{symbol}='\"#{path}\"'"
    end

    # See discussion at: https://gist.github.com/1157223
    ENV.append "CFLAGS", "-D__APPLE_USE_RFC_3542"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{dhcpd_dir}",
                          "--sysconfdir=#{etc}"

    ENV.deparallelize { system "make", "-C", "bind" }

    # build everything else
    inreplace "Makefile", "SUBDIRS = ${top_srcdir}/bind", "SUBDIRS = "
    system "make"
    system "make", "install"

    # create the state dir and lease files else dhcpd will not start up.
    dhcpd_dir.mkpath
    %w[dhcpd dhcpd6 dhclient dhclient6].each do |f|
      file = "#{dhcpd_dir}/#{f}.leases"
      File.new(file, File::CREAT|File::RDONLY).close
    end

    # dhcpv6 plists
    (prefix/"homebrew.mxcl.dhcpd6.plist").write plist_dhcpd6
    (prefix/"homebrew.mxcl.dhcpd6.plist").chmod 0644
  end

  def caveats
    <<~EOS
      This install of dhcpd expects config files to be in #{etc}.
      All state files (leases and pids) are stored in #{var}/dhcpd.

      Dhcpd needs to run as root since it listens on privileged ports.

      There are two plists because a single dhcpd process may do either
      DHCPv4 or DHCPv6 but not both. Use one or both as needed.

      Note that you must create the appropriate config files before starting
      the services or dhcpd will refuse to run.
        DHCPv4: #{etc}/dhcpd.conf
        DHCPv6: #{etc}/dhcpd6.conf

      Sample config files may be found in #{etc}.
    EOS
  end

  plist_options startup: true

  service do
    run [opt_sbin/"dhcpd", "-f"]
    keep_alive true
  end

  def plist_dhcpd6
    <<~EOS
      <?xml version='1.0' encoding='UTF-8'?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
                      "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version='1.0'>
      <dict>
      <key>Label</key><string>#{plist_name}</string>
      <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/dhcpd</string>
          <string>-f</string>
          <string>-6</string>
          <string>-cf</string>
          <string>#{etc}/dhcpd6.conf</string>
        </array>
      <key>Disabled</key><false/>
      <key>KeepAlive</key><true/>
      <key>RunAtLoad</key><true/>
      <key>LowPriorityIO</key><true/>
      </dict>
      </plist>
    EOS
  end

  test do
    cp etc/"dhcpd.conf.example", testpath/"dhcpd.conf"
    system sbin/"dhcpd", "-cf", "#{testpath}/dhcpd.conf", "-t"
  end
end
