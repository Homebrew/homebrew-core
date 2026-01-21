class Nagios < Formula
  desc "Network monitoring and management system"
  homepage "https://www.nagios.org/"
  url "https://github.com/NagiosEnterprises/nagioscore/releases/download/nagios-4.5.11/nagios-4.5.11.tar.gz"
  sha256 "1bf85d6704a75e6b89a09844836f68b1cfc61ab1ef005574041e36e73fdb797a"
  license "GPL-2.0-only"
  head "https://github.com/NagiosEnterprises/nagioscore.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "cf495efaf03c9bf44e11de31ff88efee563d783133903657be21a10cdd9a421d"
    sha256 arm64_sequoia: "f4513efe57237dd6f4e62bbab3e1ee7cca5f2df6fb880a2e69638e3e84d0dcb3"
    sha256 arm64_sonoma:  "0e2432c3152f6e8cfb5d8cbb50688280358e36cacf4d2264ab6017280c54ad84"
    sha256 sonoma:        "e8eb8ff69b92c0bdb715caf103bde96054be45b270c90b1967d4f572dd871b49"
    sha256 arm64_linux:   "b0e8d4749df2e3da474b03d2065526ef728871ec52532520c5d9976d5ec455b2"
    sha256 x86_64_linux:  "38262137b8017e82bdc3f3c07a6edf0ee4e211233ffd4b0479809dc4c6c0e885"
  end

  depends_on xcode: :build
  depends_on "gd"
  depends_on "libpng"
  depends_on "openssl@3"

  uses_from_macos "unzip"

  on_macos do
    depends_on "jpeg-turbo"
  end

  # Fix compilation error on in lib/runcmd.c; https://github.com/NagiosEnterprises/nagioscore/pull/1048
  patch do
    url "https://github.com/NagiosEnterprises/nagioscore/commit/874a7688fca646f14eef17abf744d8561c60c0c2.patch?full_index=1"
    sha256 "c7d3a4a6d5f918a67a7b49f9cd30af45234510ad1697745313dbcfa4ff767ad0"
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
    log_path File::NULL
    error_log_path File::NULL
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nagios --version")
  end
end
