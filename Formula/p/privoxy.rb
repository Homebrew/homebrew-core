class Privoxy < Formula
  desc "Advanced filtering web proxy"
  homepage "https://www.privoxy.org/"
  url "https://downloads.sourceforge.net/project/ijbswa/Sources/4.1.0%20%28stable%29/privoxy-4.1.0-stable-src.tar.gz"
  sha256 "23e4686e5848c74cb680c09c2811f0357739ecfe641f9c4072ee42399092c97b"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/privoxy[._-]v?(\d+(?:\.\d+)+)[._-]stable[._-]src\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "c0ae969ac878ba8034f22bc56240e5994bd9a042116fc7e7d23fa788fe1e484e"
    sha256 cellar: :any,                 arm64_sequoia: "82c2364535cd0c530fd02bf4082021445c4fe23b68fa2cb509ff801a37f6ef43"
    sha256 cellar: :any,                 arm64_sonoma:  "c480bbb71e9cdac494396bd35a155410a2970989c7e1557f9b4727e262b4d052"
    sha256 cellar: :any,                 sonoma:        "65fe313f31698cef56c5537b4edc8b475ea94b23cbd46e8e598e02d2644a4dd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38b56a0785bf29774bfe49fc96a7746b5b1434075aeef27f089fdd9ed47b2a95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71ec0d7dd8b9eaa5d3729dfda746c25ae91eba7dfc3d28ef35861778b3dbf003"
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
