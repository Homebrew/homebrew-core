class Ngrep < Formula
  desc "Network grep"
  homepage "https://github.com/jpr5/ngrep"
  url "https://github.com/jpr5/ngrep/archive/V1_47.tar.gz"
  sha256 "dc4dbe20991cc36bac5e97e99475e2a1522fd88c59ee2e08f813432c04c5fff3"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0d1948b2fbf7c60fb6e46f15d32a51a3f7754e7372924e4e984cce98282ca281" => :mojave
    sha256 "390424274552105e21b3f3e926b933322a09333cee02274d2f84a5e23f4ea74d" => :high_sierra
    sha256 "0e915d1e3b7e7da8e58a48457de4e40359cb0f870eb45a77302d36c1b767d044" => :sierra
    sha256 "d057c167d3b695ff915c13fd39e3cd7b3e6e2a5b3f82bce6bb8ea4c030e8f6e7" => :el_capitan
  end

  def install
    sdk = MacOS.sdk_path_if_needed ? MacOS.sdk_path : ""
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
