class Nagios < Formula
  desc "Network monitoring and management system"
  homepage "https://www.nagios.org/"
  url "https://downloads.sourceforge.net/project/nagios/nagios-4.x/nagios-4.5.2/nagios-4.5.2.tar.gz"
  sha256 "84dd5bc03c5280484ada3a8c1f446499c437bc1e6f631f6440409071d4ea3d21"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/nagios[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "c71c9fa9a96a3f6b9541b8f8175a2b0e8d3bd56dea243ba8f442e5daee2ec589"
    sha256 arm64_ventura:  "030d44d8c6a8b4604f24f5a24fcd20dee2350f43b4d98cd699c201aa79c4c7b6"
    sha256 arm64_monterey: "9bb39488ba73d387d9635e4e3903b25b18471c8554179426a0c440ef82c6273a"
    sha256 sonoma:         "c2f5dee2a9251563c70a5e261ee735c152749fff8fffe14bc9ccbd01b9330b43"
    sha256 ventura:        "2b8b536161bae53d5894c81bc4810f6a27f64d6134e35ee1536f29dcf1a2693b"
    sha256 monterey:       "87c0108fa9deba73637c036d44f3eee9025e0dd22c1eed75631274b4af624073"
    sha256 x86_64_linux:   "41c0e4cb868ab16dbd70de1bc49c00c8351b340dc65ac9bd2203b9508b135882"
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
