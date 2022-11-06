class Ddclient < Formula
  desc "Update dynamic DNS entries"
  homepage "https://ddclient.net/"
  url "https://github.com/ddclient/ddclient/archive/v3.10.0.tar.gz"
  sha256 "34b6d9a946290af0927e27460a965ad018a7c525625063b0f380cbddffc01c1b"
  license "GPL-2.0-or-later"
  head "https://github.com/ddclient/ddclient.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3a0a4ceb683ea6e8513a35882976dc58f7664708f054a32027320938e2257ae7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  uses_from_macos "perl"

  def install
    system "./autogen"
    system "./configure", *std_configure_args, "--sysconfdir=#{etc}", "--localstatedir=#{var}", "CURL=curl"
    system "make", "install", "CURL=curl"

    # Install sample files
    inreplace "sample-ddclient-wrapper.sh", "/etc/ddclient", "#{etc}/ddclient"
    inreplace "sample-etc_cron.d_ddclient", "/usr/bin/ddclient", "#{opt_bin}/ddclient"

    doc.install %w[sample-ddclient-wrapper.sh sample-etc_cron.d_ddclient]
  end

  def post_install
    (var/"run").mkpath
    chmod "go-r", etc/"ddclient.conf"

    # Migrate old configuration files to the new location that `ddclient` checks.
    # Remove on 31/12/2023.
    old_config_file = pkgetc/"ddclient.conf"
    return unless old_config_file.exist?

    new_config_file = etc/"ddclient.conf"
    ohai "Migrating `#{old_config_file}` to `#{new_config_file}`..."
    etc.install new_config_file => "ddclient.conf.default" if new_config_file.exist?
    etc.install old_config_file
    pkgetc.rmtree if pkgetc.empty?
  end

  def caveats
    <<~EOS
      For ddclient to work, you will need to customise the configuration
      file at `#{etc}/ddclient.conf`.

      Note: don't enable daemon mode in the configuration file; see
      additional information below.

      The next reboot of the system will automatically start ddclient.

      You can adjust the execution interval by changing the value of
      StartInterval (in seconds) in /Library/LaunchDaemons/#{launchd_service_path.basename}.
    EOS
  end

  service do
    run [opt_bin/"ddclient", "-file", etc/"ddclient.conf"]
    run_type :interval
    interval 300
    require_root true
    working_dir etc/"ddclient"
  end

  test do
    begin
      pid = fork do
        exec bin/"ddclient", "-file", etc/"ddclient.conf", "-debug", "-verbose", "-noquiet"
      end
      sleep 1
    ensure
      Process.kill "TERM", pid
      Process.wait
    end
    $CHILD_STATUS.success?
  end
end
