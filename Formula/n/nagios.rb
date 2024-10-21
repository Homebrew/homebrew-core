class Nagios < Formula
  desc "Network monitoring and management system"
  homepage "https://www.nagios.org/"
  url "https://downloads.sourceforge.net/project/nagios/nagios-4.x/nagios-4.5.6/nagios-4.5.6.tar.gz"
  sha256 "10749a488fe372c659191562e43f4409c54907b9501e3a588759560927d9c98e"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/nagios[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "a6368434e35f510a0db719718bc2d51e58e6ccac5625234fce9d21375454aece"
    sha256 arm64_sonoma:  "ca135fe42ef3f2dfb7edf011305b1d85734b83e444c733886de0f4b9133937e3"
    sha256 arm64_ventura: "35afbec30039f2e5b39c014d15dc540cb580cfab7223303230e4bf6d97be752e"
    sha256 sonoma:        "bad4bf479dc68c61f35d068492ef23b83cc8ec74a6a7118f529a2b6f67aafdda"
    sha256 ventura:       "5518a6656c76555c5216eaebadebeeb19f917589096cb8a5ff7f3463143ee822"
    sha256 x86_64_linux:  "8b4e9f353c459a4fc5a521361d2a3530eb8f97b8cb92c1044561524fc9aceb78"
  end

  depends_on "gd"
  depends_on "libpng"
  depends_on "openssl@3"

  uses_from_macos "unzip"

  on_macos do
    depends_on "jpeg-turbo"
  end

  def nagios_sbin
    prefix/"cgi-bin"
  end

  def nagios_etc
    etc/"nagios"
  end

  def nagios_var
    var/"lib/nagios"
  end

  def htdocs
    pkgshare/"htdocs"
  end

  def user
    Utils.safe_popen_read("id", "-un").chomp
  end

  def group
    Utils.safe_popen_read("id", "-gn").chomp
  end

  def install
    args = [
      "--sbindir=#{nagios_sbin}",
      "--sysconfdir=#{nagios_etc}",
      "--localstatedir=#{nagios_var}",
      "--datadir=#{htdocs}",
      "--libexecdir=#{HOMEBREW_PREFIX}/sbin", # Plugin dir
      "--with-cgiurl=/nagios/cgi-bin",
      "--with-htmurl=/nagios",
      "--with-nagios-user=#{user}",
      "--with-nagios-group='#{group}'",
      "--with-command-user=#{user}",
      "--with-httpd-conf=#{share}",
      "--with-ssl=#{Formula["openssl@3"].opt_prefix}",
      "--disable-libtool",
    ]
    args << "--with-command-group=_www" if OS.mac?

    system "./configure", *std_configure_args, *args
    system "make", "all"
    system "make", "install"

    # Install config
    system "make", "install-config"
    system "make", "install-webconf"
  end

  def post_install
    (var/"lib/nagios/rw").mkpath

    config = etc/"nagios/nagios.cfg"
    return unless config.exist?
    return if config.read.include?("nagios_user=#{ENV["USER"]}")

    inreplace config, /^nagios_user=.*/, "nagios_user=#{ENV["USER"]}"
  end

  service do
    run [opt_bin/"nagios", etc/"nagios/nagios.cfg"]
    keep_alive true
    require_root true
    log_path "/dev/null"
    error_log_path "/dev/null"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nagios --version")
  end
end
