class Ngrep < Formula
  desc "Network grep"
  homepage "https://github.com/jpr5/ngrep"
  url "https://github.com/jpr5/ngrep/archive/V1_47.tar.gz"
  sha256 "dc4dbe20991cc36bac5e97e99475e2a1522fd88c59ee2e08f813432c04c5fff3"

  bottle do
    cellar :any_skip_relocation
    sha256 "ca38ebeb13f8eb4bbccd30f73e7dc7fc50147b1be878bdc19440af3ee062ef02" => :high_sierra
    sha256 "0343c66af5a27bfd98dffd1e81fb73cca734b90996bc2d66761dc942c1ad729d" => :sierra
    sha256 "e01abe517e9dca78fe2e89f787ef373be7cf00aef686e221b14a8c9fe2b48355" => :el_capitan
  end

  def install
    sdk = MacOS::CLT.installed? ? "" : MacOS.sdk_path
    system "./configure", "--enable-ipv6",
                          "--prefix=#{prefix}",
                          # this line required to make configure succeed
                          "--with-pcap-includes=#{sdk}/usr/include/pcap",
                          # this line required to avoid segfaults
                          # see https://github.com/jpr5/ngrep/commit/e29fc29
                          # https://github.com/Homebrew/homebrew/issues/27171
                          "--disable-pcap-restart"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ngrep -V")
  end
end
