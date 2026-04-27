class Nagios < Formula
  desc "Network monitoring and management system"
  homepage "https://www.nagios.org/"
  url "https://github.com/NagiosEnterprises/nagioscore/releases/download/nagios-4.5.12/nagios-4.5.12.tar.gz"
  sha256 "9a9fd281ea6ab3d55611efda036ffb9fe76c98423083440900e28012248d5961"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/NagiosEnterprises/nagioscore.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "1d524bcd5a8f97604396f7969ce07b562dccecbd0e2f0f4e64cc2d149fa6b0bd"
    sha256 arm64_sequoia: "df7ba48825b6f3ff74769a763c8128621beda40bdecf3b13d259776766ed248c"
    sha256 arm64_sonoma:  "5c65c296ff0a0f2d97593f8b4f3b0c576c177305bc8674aec44faf7f819791e1"
    sha256 sonoma:        "d78bdc8ff14af5f05e2dcb738e99dfa5a8fb8bcacb677c13a8d3d2c2fd9616d7"
    sha256 arm64_linux:   "edbadc0b772d969302fa4b34025732451b56eb0ef9989a39c9de3e76ee81070d"
    sha256 x86_64_linux:  "0bcbba0785cf2f8cc846196ce8d7307d700b7502ffe7368d1b86406e906213eb"
  end

  depends_on xcode: :build
  depends_on "gd"
  depends_on "libpng"
  depends_on "openssl@4"

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
      "--with-ssl=#{Formula["openssl@4"].opt_prefix}",
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
