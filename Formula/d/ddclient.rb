class Ddclient < Formula
  desc "Update dynamic DNS entries"
  homepage "https://ddclient.net/"
  url "https://github.com/ddclient/ddclient/archive/refs/tags/v4.0.0.tar.gz"
  sha256 "4b37c99ac0011102d7db62f1ece7ff899b06df3d4b172e312703931a3c593c93"
  license "GPL-2.0-or-later"
  head "https://github.com/ddclient/ddclient.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "295bbe6bc8b84952958cac5b33b021419cb51002f95c8c6a1f1eb67ff9b2cb72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "295bbe6bc8b84952958cac5b33b021419cb51002f95c8c6a1f1eb67ff9b2cb72"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "295bbe6bc8b84952958cac5b33b021419cb51002f95c8c6a1f1eb67ff9b2cb72"
    sha256 cellar: :any_skip_relocation, sonoma:        "295bbe6bc8b84952958cac5b33b021419cb51002f95c8c6a1f1eb67ff9b2cb72"
    sha256 cellar: :any_skip_relocation, ventura:       "295bbe6bc8b84952958cac5b33b021419cb51002f95c8c6a1f1eb67ff9b2cb72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d72d15c820e4ca74fe4dab7e004c7346b33d8aaf793a84f7169f0a804cf4e61b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c48a16e4d1c11696c5561210e47f3bb922c10f7b7bfdd0f6d3298bf0814d0caf"
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
    chmod "go-r", pkgetc/"ddclient.conf"
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
