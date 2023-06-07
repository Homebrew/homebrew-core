class Nagios < Formula
  desc "Network monitoring and management system"
  homepage "https://www.nagios.org/"
  url "https://downloads.sourceforge.net/project/nagios/nagios-4.x/nagios-4.4.13/nagios-4.4.13.tar.gz"
  sha256 "c289488c7ba71e66aae9890113eee475b9cedfe92f663a899ac6f70764fc1727"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/nagios[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "d6a96a2e9b03010cdc0eefcc395cce7efff7726a6b167b89840489085c97dc1f"
    sha256 arm64_monterey: "e6583561477d29f57b65e5c064a0b7e2cce2523c8ef50230f3edd41873d8b5fb"
    sha256 arm64_big_sur:  "952f5e980df84edb781d3edd3382882289da986aba91a6b48d3532a77d981aa1"
    sha256 ventura:        "0a64821eb737ba69852735ee1dc1d5303a0f071a9ba68e5deb828fe536435e60"
    sha256 monterey:       "2618b63439e2cc5e909beeabf93bee6e055d1b69a523ed9141c9df50baf7def5"
    sha256 big_sur:        "df7a95509c5372787ecd8bfc8dc94e505d34da8f5543b972e7e54a666b61b8f7"
    sha256 x86_64_linux:   "09c36efc9f60302dac7b25a9d72f1c51ad449c28243a4965f18ad847c047f4c0"
  end

  depends_on "gd"
  depends_on "libpng"
  depends_on "nagios-plugins"
  depends_on "openssl@3"

  uses_from_macos "unzip"

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
