class Privoxy < Formula
  desc "Advanced filtering web proxy"
  homepage "https://www.privoxy.org/"
  url "https://downloads.sourceforge.net/project/ijbswa/Sources/4.2.0%20%28stable%29/privoxy-4.2.0-stable-src.tar.gz"
  sha256 "6f91267f81f626c416994db89ab62f4d09246eebf4754b81186e13a18ee9028f"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/privoxy[._-]v?(\d+(?:\.\d+)+)[._-]stable[._-]src\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6e5513f208bd8a7fe5f898b67df312f8802bbea004d7b9bd294f44f88a47d1e5"
    sha256 cellar: :any, arm64_sequoia: "0324d517534b62d310ab88724683b84fc708054ef5b8717331c9edf5b12d3130"
    sha256 cellar: :any, arm64_sonoma:  "5d4b836788302465c6866179751beafd2774d1d70c4877e1457d523592760277"
    sha256 cellar: :any, sonoma:        "479b063a010e04595327e543eda74f17cbcb9b4e21adbe08790199f8aac62822"
    sha256 cellar: :any, arm64_linux:   "ac4d630fc0561bcd2c6bc4fd746eb6d093790c6fd48fe9018b1b420cd59cd86d"
    sha256 cellar: :any, x86_64_linux:  "835c554f82dcbe4bb90a8e96afddfc294a3b0805e09091b2e1024c42066b7507"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pcre2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--sysconfdir=#{pkgetc}",
                          "--localstatedir=#{var}",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  service do
    run [opt_sbin/"privoxy", "--no-daemon", etc/"privoxy/config"]
    keep_alive true
    working_dir var
    error_log_path var/"log/privoxy/logfile"
  end

  test do
    bind_address = "127.0.0.1:#{free_port}"
    (testpath/"config").write("listen-address #{bind_address}\n")
    pid = spawn sbin/"privoxy", "--no-daemon", testpath/"config"
    begin
      sleep 5
      output = shell_output("curl --head --proxy #{bind_address} https://github.com")
      assert_match "HTTP/1.1 200 Connection established", output
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
