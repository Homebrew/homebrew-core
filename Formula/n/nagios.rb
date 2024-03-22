class Nagios < Formula
  desc "Network monitoring and management system"
  homepage "https://www.nagios.org/"
  url "https://downloads.sourceforge.net/project/nagios/nagios-4.x/nagios-4.5.1/nagios-4.5.1.tar.gz"
  sha256 "171fc577e026e32079d17057cd49a9730bb86e44169c4735d9b66fa0b43e045a"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/nagios[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "44b35fd331fec99514d9d5fb559bbb0cc21b8276ef3f050e96f997bcd1e96a0e"
    sha256 arm64_ventura:  "645328ada7e1956785b7359c37a0d850016fa41bd56f83983bf6fc4bce3e6952"
    sha256 arm64_monterey: "91e060ed13d94d14a06f747881f9579264e65369fbe8d49c22f3a559b18f04f8"
    sha256 sonoma:         "95549ba58d7878a81d5b993665d4fa9feaf92fc6328f8a92b90174578a2996c2"
    sha256 ventura:        "e8feb3277ca45a3a19cc7d972d3b9abd750042d0fbc523937983a13510e641f3"
    sha256 monterey:       "ada9f2c58a705e4fcafe560c1cc5161eabc6e753522b6aba6c63079cd8022a3e"
    sha256 x86_64_linux:   "fdeee67e8a7d30dbf97c50e5c00f2b69a0248a0300c6a16b68dfa7d720086dce"
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
