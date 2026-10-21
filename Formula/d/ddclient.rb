class Ddclient < Formula
  desc "Update dynamic DNS entries"
  homepage "https://ddclient.net/"
  url "https://github.com/ddclient/ddclient/releases/download/v4.0.0/ddclient-4.0.0.tar.gz"
  sha256 "15c73d4b61e8e4974707379df1dbf15ab9f933835c6968947d2b56173388c6f0"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, all: "dd5a0ecc4036f9ed9f287ea1240f09cbc2bf2cfeb5d672069e3ea384465ceb9c"
  end

  head do
    url "https://github.com/ddclient/ddclient.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  uses_from_macos "perl"

  def install
    system "./autogen" if build.head?
    system "./configure", "--sysconfdir=#{etc}", "--localstatedir=#{var}", "CURL=curl", *std_configure_args
    system "make", "install", "CURL=curl"

    # Ensure uniform bottles across architectures
    inreplace bin/"ddclient" do |s|
      s.gsub!(%r{/(usr/local|opt/homebrew)}, HOMEBREW_PREFIX, audit_result: false)
    end

    # Install sample files
    inreplace "sample-ddclient-wrapper.sh", "/etc/ddclient/", "#{pkgetc}/"
    inreplace "sample-etc_cron.d_ddclient", "/usr/bin/ddclient", "#{opt_bin}/ddclient"

    doc.install %w[sample-ddclient-wrapper.sh sample-etc_cron.d_ddclient]

    (var/"run").mkpath
    chmod "go-r", pkgetc/"ddclient.conf"
  end

  def caveats
    <<~EOS
      For ddclient to work, you will need to customise the configuration
      file at `#{pkgetc}/ddclient.conf`.

      Note: don't enable daemon mode in the configuration file; see
      additional information below.

      The next reboot of the system will automatically start ddclient.

      You can adjust the execution interval by changing the value of
      StartInterval (in seconds) in /Library/LaunchDaemons/#{launchd_service_path.basename}.
    EOS
  end

  service do
    run [opt_bin/"ddclient", "-file", etc/"ddclient/ddclient.conf"]
    run_type :interval
    interval 300
    require_root true
  end

  test do
    begin
      pid = spawn bin/"ddclient", "-file", pkgetc/"ddclient.conf", "-debug", "-verbose", "-noquiet"
      sleep 1
    ensure
      Process.kill "TERM", pid
      Process.wait
    end
    $CHILD_STATUS.success?

    assert_equal "0600", (pkgetc/"ddclient.conf").stat.mode.to_s(8)[-4..], "ddclient.conf permissions"
  end
end
