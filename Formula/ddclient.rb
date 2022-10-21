class Ddclient < Formula
  desc "Update dynamic DNS entries"
  homepage "https://ddclient.net/"
  url "https://github.com/ddclient/ddclient/archive/v3.10.0.tar.gz"
  sha256 "34b6d9a946290af0927e27460a965ad018a7c525625063b0f380cbddffc01c1b"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1bb00351331eb6595be094e2c0a2e508f7cb12e7eb126eea25b6ee6ca8dfce0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bec2f1275e4b3ab4c39af7ba4f8d9a4a12782549ebda1b36f0ccf62126ad49dd"
    sha256 cellar: :any_skip_relocation, monterey:       "242c680a8427a15d2ea8570e3bb87dd507c17424aa2325fdd1dc71f6d2d0ffb1"
    sha256 cellar: :any_skip_relocation, big_sur:        "7dc3fcde51897744a371694203d03664cddb655bac7ef4249b1c753917db8040"
    sha256 cellar: :any_skip_relocation, catalina:       "356aa5bc066e521429ae4474ee978bad0c596045a9d1d4efa4cc46acd0e0e66f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90860f823cc3568a81e12dda3412adbe8d6fdcf13ea50b343489c584c9d3d384"
  end

  head do
    url "https://github.com/ddclient/ddclient.git", branch: "develop"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  uses_from_macos "perl"

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5" if resources.present?

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make"
        system "make", "install"
      end
    end

    if build.head?
      system "./autogen"
      system "./configure", *std_configure_args, "--sysconfdir=#{etc}", "--localstatedir=#{var}", "CURL=curl"
      system "make", "install", "CURL=curl"
    else
      # Adjust default paths in script
      inreplace "ddclient" do |s|
        s.gsub! "/etc/ddclient", "#{etc}/ddclient"
        s.gsub! "/var/cache/ddclient", "#{var}/run/ddclient"
      end

      sbin.install "ddclient"
      sbin.env_script_all_files(libexec/"sbin", PERL5LIB: ENV["PERL5LIB"])
    end

    # Install sample files
    inreplace "sample-ddclient-wrapper.sh", "/etc/ddclient", "#{etc}/ddclient"
    inreplace "sample-etc_cron.d_ddclient", %r{/usr/s?bin/ddclient}, "#{sbin}/ddclient"
    inreplace "sample-etc_ddclient.conf", "/var/run/ddclient.pid", "#{var}/run/ddclient/pid"

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
