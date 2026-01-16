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
    sha256 cellar: :any,                 arm64_tahoe:   "711388f3a2676dfdbd54e2653f477c1f75b08702efb67fe45785d92ed1c7f47e"
    sha256 cellar: :any,                 arm64_sequoia: "0cc5e99582a9045a4a09b818eea04c6a2d44b0cf429b8616e95b5263142df2a9"
    sha256 cellar: :any,                 arm64_sonoma:  "689b7feae3d74e45dd819b5fc99660465622b03d7317ee183c1baf3ba30882f4"
    sha256 cellar: :any,                 sonoma:        "fd44e98d51314e7ac4d518684d7931a1baf48aa34e946630c6a15aad737a0065"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7832b8650f419d38f63f27f48c5a669208dfd714d5469cfe5ca7cb0d8901519c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fda2b1458d6b7067b029dc05e8f4c1c1d5b9d19fab689f052f8431276248b0a7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pcre2"

  uses_from_macos "zlib"

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
