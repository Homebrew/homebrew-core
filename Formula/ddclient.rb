class Ddclient < Formula
  desc "Update dynamic DNS entries"
  homepage "https://sourceforge.net/p/ddclient/wiki/Home"
  url "https://downloads.sourceforge.net/project/ddclient/ddclient/ddclient-3.9.0/ddclient-3.9.0.tar.gz"
  sha256 "9c4ae902742e8a37790d3cc8fad4e5b0f38154c76bba3643f4423d8f96829e3b"
  head "https://github.com/wimpunk/ddclient.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb9631a6394ad174c9b28da23e66ddd2487aec8288874e0341b28bb5b2a42209" => :mojave
    sha256 "f53e130d1b87b70e10fc6746ef5270d4e25031c8c6f4ba2e2ffcb3d3799e09ca" => :high_sierra
    sha256 "3314806cf6fe3e64da60949fb77973ef4c38d56830050a404fcdabf5ba27c777" => :sierra
    sha256 "d3ef79c5455f31ed75a662be41262c51838a6164fd68b08868ed90c2ee511efc" => :el_capitan
  end

  resource "Data::Validate::IP" do
    url "https://cpan.metacpan.org/authors/id/D/DR/DROLSKY/Data-Validate-IP-0.27.tar.gz"
    sha256 "e1aa92235dcb9c6fd9b6c8cda184d1af73537cc77f4f83a0f88207a8bfbfb7d6"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    # Adjust default paths in script
    inreplace "ddclient" do |s|
      s.gsub! "/etc/ddclient", "#{etc}/ddclient"
      s.gsub! "/var/cache/ddclient", "#{var}/run/ddclient"
    end

    sbin.install "ddclient"
    sbin.env_script_all_files(libexec/"sbin", :PERL5LIB => ENV["PERL5LIB"])

    # Install sample files
    inreplace "sample-ddclient-wrapper.sh",
      "/etc/ddclient", "#{etc}/ddclient"

    inreplace "sample-etc_cron.d_ddclient",
      "/usr/sbin/ddclient", "#{sbin}/ddclient"

    inreplace "sample-etc_ddclient.conf",
      "/var/run/ddclient.pid", "#{var}/run/ddclient/pid"

    doc.install %w[
      sample-ddclient-wrapper.sh
      sample-etc_cron.d_ddclient
      sample-etc_ddclient.conf
    ]
  end

  def post_install
    (etc/"ddclient").mkpath
    (var/"run/ddclient").mkpath
  end

  def caveats; <<~EOS
    For ddclient to work, you will need to create a configuration file
    in #{etc}/ddclient, a sample configuration can be found in
    #{opt_share}/doc/ddclient.

    Note: don't enable daemon mode in the configuration file; see
    additional information below.

    The next reboot of the system will automatically start ddclient.

    You can adjust the execution interval by changing the value of
    StartInterval (in seconds) in /Library/LaunchDaemons/#{plist_path.basename},
    and then
  EOS
  end

  plist_options :startup => true

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_sbin}/ddclient</string>
        <string>-file</string>
        <string>#{etc}/ddclient/ddclient.conf</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>StartInterval</key>
      <integer>300</integer>
      <key>WatchPaths</key>
      <array>
        <string>#{etc}/ddclient</string>
      </array>
      <key>WorkingDirectory</key>
      <string>#{etc}/ddclient</string>
    </dict>
    </plist>
  EOS
  end

  test do
    begin
      pid = fork do
        exec sbin/"ddclient", "-file", doc/"sample-etc_ddclient.conf", "-debug", "-verbose", "-noquiet"
      end
      sleep 1
    ensure
      Process.kill "TERM", pid
      Process.wait
    end
    $CHILD_STATUS.success?
  end
end
