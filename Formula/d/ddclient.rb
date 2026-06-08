class Ddclient < Formula
  desc "Update dynamic DNS entries"
  homepage "https://ddclient.net/"
  url "https://github.com/ddclient/ddclient/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "4b37c99ac0011102d7db62f1ece7ff899b06df3d4b172e312703931a3c593c93"
  license "GPL-2.0-or-later"
  head "https://github.com/ddclient/ddclient.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d963690c63fb5f28fe5729c3a98d43dc3822508658b4f5e9a335bd19b6956903"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d963690c63fb5f28fe5729c3a98d43dc3822508658b4f5e9a335bd19b6956903"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d963690c63fb5f28fe5729c3a98d43dc3822508658b4f5e9a335bd19b6956903"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd6b4f96c529a8bd8540e0963f1e349bff91348e9f74bd52e78d1ec6f188ff1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d963690c63fb5f28fe5729c3a98d43dc3822508658b4f5e9a335bd19b6956903"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d963690c63fb5f28fe5729c3a98d43dc3822508658b4f5e9a335bd19b6956903"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "perl"

  def install
    system "./autogen"
    system "./configure", "--sysconfdir=#{etc}", "--localstatedir=#{var}", "CURL=curl", *std_configure_args
    system "make", "install", "CURL=curl"

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
