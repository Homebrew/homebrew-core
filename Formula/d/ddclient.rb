class Ddclient < Formula
  desc "Update dynamic DNS entries"
  homepage "https://ddclient.net/"
  url "https://github.com/ddclient/ddclient/archive/refs/tags/v3.11.2.tar.gz"
  sha256 "243cd832abd3cdd2b49903e1b5ed7f450e2d9c4c0eaf8ce4fe692c244d3afd77"
  license "GPL-2.0-or-later"
  head "https://github.com/ddclient/ddclient.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "528b406d3d5259581701d70b58cfbab489a050f28ad638cd96fef4c7b717c8fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "414220db19df958c45f3d8ad699841ac8e115d1cba7a2c2b3768e36c9e0bbfbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "414220db19df958c45f3d8ad699841ac8e115d1cba7a2c2b3768e36c9e0bbfbd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "414220db19df958c45f3d8ad699841ac8e115d1cba7a2c2b3768e36c9e0bbfbd"
    sha256 cellar: :any_skip_relocation, sonoma:         "414220db19df958c45f3d8ad699841ac8e115d1cba7a2c2b3768e36c9e0bbfbd"
    sha256 cellar: :any_skip_relocation, ventura:        "414220db19df958c45f3d8ad699841ac8e115d1cba7a2c2b3768e36c9e0bbfbd"
    sha256 cellar: :any_skip_relocation, monterey:       "414220db19df958c45f3d8ad699841ac8e115d1cba7a2c2b3768e36c9e0bbfbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99341145cb0d0dcd3e2f2da1b726372b72e33a5ac9807d1b8f5a0bab26392078"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "perl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"

    resource "IO::Socket::INET6" do
      url "https://cpan.metacpan.org/authors/id/S/SH/SHLOMIF/IO-Socket-INET6-2.73.tar.gz"
      sha256 "b6da746853253d5b4ac43191b4f69a4719595ee13a7ca676a8054cf36e6d16bb"
    end

    resource "IO::Socket::SSL" do
      url "https://cpan.metacpan.org/authors/id/S/SU/SULLR/IO-Socket-SSL-2.084.tar.gz"
      sha256 "a60d1e04e192363155329560498abd3412c3044295dae092d27fb6e445c71ce1"
    end

    resource "JSON::PP" do
      url "https://cpan.metacpan.org/authors/id/I/IS/ISHIGAKI/JSON-PP-4.16.tar.gz"
      sha256 "8bc2f162bafc42645c489905ad72540f0d3c284b360c96299095183c30cc9789"
    end

    resource "Net::SSLeay" do
      url "https://cpan.metacpan.org/authors/id/C/CH/CHRISN/Net-SSLeay-1.92.tar.gz"
      sha256 "47c2f2b300f2e7162d71d699f633dd6a35b0625a00cbda8c50ac01144a9396a9"
    end
  end

  # disable automake treating warnings as error, upstream pr ref, https://github.com/ddclient/ddclient/pull/746
  patch do
    url "https://github.com/ddclient/ddclient/commit/9eb4558772b84516363c960fe53c014575d80df9.patch?full_index=1"
    sha256 "e491f223f033aad7c213cd9a1a761fefffc6220660e3f4ac150ca65e1381cf7a"
  end

  def install
    if OS.linux?
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
      ENV["PERL_MM_USE_DEFAULT"] = "1"
      ENV["OPENSSL_PREFIX"] = Formula["openssl@3"].opt_prefix

      resources.each do |r|
        r.stage do
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
          system "make", "install"
        end
      end
    end

    system "./autogen"
    system "./configure", *std_configure_args, "--sysconfdir=#{etc}", "--localstatedir=#{var}", "CURL=curl"
    system "make", "install", "CURL=curl"

    # Install sample files
    inreplace "sample-ddclient-wrapper.sh", "/etc/ddclient", "#{etc}/ddclient"
    inreplace "sample-etc_cron.d_ddclient", "/usr/bin/ddclient", "#{opt_bin}/ddclient"

    doc.install %w[sample-ddclient-wrapper.sh sample-etc_cron.d_ddclient]
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"]) if OS.linux?
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
    rm_r(pkgetc) if pkgetc.empty?
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
