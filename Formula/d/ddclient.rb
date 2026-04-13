class Ddclient < Formula
  desc "Update dynamic DNS entries"
  homepage "https://ddclient.net/"
  url "https://github.com/ddclient/ddclient/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "4b37c99ac0011102d7db62f1ece7ff899b06df3d4b172e312703931a3c593c93"
  license "GPL-2.0-or-later"
  head "https://github.com/ddclient/ddclient.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd99a31bc382b37fb1c30b0951207f62cac95ca4a63e1aa8b33418d8c7835b02"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd99a31bc382b37fb1c30b0951207f62cac95ca4a63e1aa8b33418d8c7835b02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd99a31bc382b37fb1c30b0951207f62cac95ca4a63e1aa8b33418d8c7835b02"
    sha256 cellar: :any_skip_relocation, sonoma:        "f21970276380eb8695cf3d1fe7db5e34ebb4f6a30e5e016a40f09f9aaea3a463"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e668a3f6c30e6ee9161cee638436862bf180227acaf1d9d18c91f3c5fc11993"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21970b6c0bf60078a269f10b8e22da146a75f65ef69cead984b9026203664493"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "perl"

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"

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
    system "./configure", "--sysconfdir=#{etc}", "--localstatedir=#{var}", "CURL=curl", *std_configure_args
    system "make", "install", "CURL=curl"

    # Install sample files
    inreplace "sample-ddclient-wrapper.sh", "/etc/ddclient/", "#{pkgetc}/"
    inreplace "sample-etc_cron.d_ddclient", "/usr/bin/ddclient", "#{opt_bin}/ddclient"

    doc.install %w[sample-ddclient-wrapper.sh sample-etc_cron.d_ddclient]
    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"]) if OS.linux?

    (var/"run").mkpath
    chmod "go-r", pkgetc/"ddclient.conf"
  end

  def caveats
    <<~EOS
      For ddclient to work, you will need to customise the configuration
      file at `#{pkgetc}/ddclient.conf`.

      Note: don't enable daemon mode in the configuration file; see
      additional information below.

      The next reboot of the system will automatically start ddclient.

      You can adjust the execution interval by changing the value of
      StartInterval (in seconds) in /Library/LaunchDaemons/#{launchd_service_path.basename}.
    EOS
  end

  service do
    run [opt_bin/"ddclient", "-file", etc/"ddclient/ddclient.conf"]
    run_type :interval
    interval 300
    require_root true
  end

  test do
    begin
      pid = spawn bin/"ddclient", "-file", pkgetc/"ddclient.conf", "-debug", "-verbose", "-noquiet"
      sleep 1
    ensure
      Process.kill "TERM", pid
      Process.wait
    end
    $CHILD_STATUS.success?

    assert_equal "0600", (pkgetc/"ddclient.conf").stat.mode.to_s(8)[-4..], "ddclient.conf permissions"
  end
end
