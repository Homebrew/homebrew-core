class IscDhcp < Formula
  desc "Production-grade DHCP solution"
  homepage "https://www.isc.org/dhcp"
  url "https://ftp.isc.org/isc/dhcp/4.4.3-P1/dhcp-4.4.3-P1.tar.gz"
  sha256 "0ac416bb55997ca8632174fd10737fd61cdb8dba2752160a335775bc21dc73c7"
  license "MPL-2.0"

  livecheck do
    url "https://www.isc.org/download/"
    regex(%r{href=.*?/dhcp[._-]v?(\d+(?:\.\d+)+(?:-P\d+)?)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "ca26d2145b3c8040d94c1ee2b8065d1facdf47f00e4d26e93d8a15a9bab3b209"
    sha256 arm64_monterey: "53454eb5ae86cb4fe52825f7bcfec568ed205ee417d21526fa42d1c5b90141dd"
    sha256 arm64_big_sur:  "11182828a03788759a737535d2db69aa96d12df98889e62c4b8147f709b00a92"
    sha256 ventura:        "1e27788709ff517345a449edc508cfc9dc5426baa08bb3f34167acffc84c010f"
    sha256 monterey:       "a55472a7338f26f7138000677df04f90eec5eec5120168b87c72ed14b9536fbe"
    sha256 big_sur:        "a0ca57af4461f5ecad3f0882c72e3afaa78a78d46ad2393cbf553226c471107a"
    sha256 catalina:       "0c39f7765fb83025a5b24012b692c04aaf4e78cfa6a1e450e93b191b9d33e90d"
    sha256 x86_64_linux:   "6085ad7064a861fe03a25bf6ba6172d1a50cdf0f5985dc652ba32484fb7e08ca"
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
