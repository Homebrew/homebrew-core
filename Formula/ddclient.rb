class Ddclient < Formula
  desc "Update dynamic DNS entries"
  homepage "https://ddclient.net/"
  url "https://github.com/ddclient/ddclient/archive/v3.9.1.tar.gz"
  sha256 "e4969e15cc491fc52bdcd649d4c2b0e4b1bf0c9f9dba23471c634871acc52470"
  license "GPL-2.0"
  head "https://github.com/wimpunk/ddclient.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69edaf36367f1c2d3bccfff16c261caf44bd134e6f06b48a92e6b9f4b550856f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4d0f7f33c9ddd698673438ca8bb0e9d6ddd5176a57dd5b18756ecc5a204c660"
    sha256 cellar: :any_skip_relocation, monterey:       "f0b248f41b6b2520a79ef4658d52f5c336529a18cabde9bf77051d8fa4b43736"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb1d0b3b93fecafb93265cabf1b24c94d8df9e7399a820c4ae72a5dc7d5186f9"
    sha256 cellar: :any_skip_relocation, catalina:       "d4e32d3e5c88ea3d8b77caccd50e1a291e44934542279289f6e8e13203496214"
    sha256 cellar: :any_skip_relocation, mojave:         "05482e7ee83ff87306f35898b16748d0c3823d15c8879a4a4f8e6da341d299a5"
    sha256 cellar: :any_skip_relocation, high_sierra:    "45b2b534058896de6f98ab1da92d8a1f4ab71fc952b97129e94ae074cfa80b91"
  end

  uses_from_macos "perl"

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
    sbin.env_script_all_files(libexec/"sbin", PERL5LIB: ENV["PERL5LIB"])

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

  def caveats
    <<~EOS
      For ddclient to work, you will need to create a configuration file
      in #{etc}/ddclient. A sample configuration can be found in
      #{opt_share}/doc/ddclient.

      Note: don't enable daemon mode in the configuration file; see
      additional information below.

      The next reboot of the system will automatically start ddclient.

      You can adjust the execution interval by changing the value of
      StartInterval (in seconds) in /Library/LaunchDaemons/#{plist_path.basename}.
    EOS
  end

  plist_options startup: true

  service do
    run [opt_sbin/"ddclient", "-file", etc/"ddclient/ddclient.conf"]
    run_type :interval
    interval 300
    working_dir etc/"ddclient"
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
