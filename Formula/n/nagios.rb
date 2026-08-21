class Nagios < Formula
  desc "Network monitoring and management system"
  homepage "https://www.nagios.org/"
  url "https://github.com/NagiosEnterprises/nagioscore/releases/download/nagios-4.5.14/nagios-4.5.14.tar.gz"
  sha256 "dce59f306577789c56d2748471d4c3856ecba8572d6b0811cf79f9de2f9afabb"
  license "GPL-2.0-only"
  head "https://github.com/NagiosEnterprises/nagioscore.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "ba4c8b095224835ee6c835b58b2f609110e7a5df460d42ebcb686141d5063f47"
    sha256 arm64_sequoia: "50a64fd089e465294abcf6f70516d7fde65aa6260ea32f25eb387bc6c85bf75a"
    sha256 arm64_sonoma:  "a196eb64fd6d0fd3f2bcaefa579538bd8664f1de9e4cbf6c76f30c01d776582f"
    sha256 sonoma:        "b92f4b00522b8cdb201935e841aae21c81d97d0f06a2b1fbd63e68564a771a07"
    sha256 arm64_linux:   "cacba4d0bdf32593ad267845828586f06cae71f45f49e960db5e78bef9dab1cd"
    sha256 x86_64_linux:  "024222f9b5f370620b8064b39b6a936865e2f27071d1f1f728b245918993cdc0"
  end

  depends_on "gd"
  depends_on "libpng"
  depends_on "openssl@4"

  uses_from_macos "unzip" => :build

  on_macos do
    depends_on "jpeg-turbo"
  end

  def nagios_sbin = prefix/"cgi-bin"

  def nagios_etc = etc/"nagios"

  def nagios_var = var/"lib/nagios"

  def htdocs = pkgshare/"htdocs"

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
      "--with-ssl=#{formula_opt_prefix("openssl@4")}",
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

  post_install_steps do
    mkdir_p "lib/nagios/rw", base: :var
    if_path_exists "{{etc}}/nagios/nagios.cfg" do
      inreplace "nagios/nagios.cfg", /^nagios_user=.*/, "nagios_user={{user}}", base: :etc, audit_result: false
    end
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
