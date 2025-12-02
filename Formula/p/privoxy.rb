class Privoxy < Formula
  desc "Advanced filtering web proxy"
  homepage "https://www.privoxy.org/"
  url "https://downloads.sourceforge.net/project/ijbswa/Sources/4.0.0%20%28stable%29/privoxy-4.0.0-stable-src.tar.gz"
  sha256 "c08e2ba0049307017bf9d8a63dd2a0dfb96aa0cdeb34ae007776e63eba62a26f"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/privoxy[._-]v?(\d+(?:\.\d+)+)[._-]stable[._-]src\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "94236b3fa68f8bf7018b3665783ba73d85eb752d785e36e5f2e64a635125bb32"
    sha256 cellar: :any,                 arm64_sequoia: "d83863aa3c2b997f07b85eb2c0508411720d70c7d9e2d8a0d3aad6f6570dd4c7"
    sha256 cellar: :any,                 arm64_sonoma:  "5ffeba4e02190b9ef05a1991918b68f35816922b1e5ea18222823abd3b04efae"
    sha256 cellar: :any,                 arm64_ventura: "320b704c330b960bff73567056912529c9840b7be022b2fa36d336755fab634e"
    sha256 cellar: :any,                 sonoma:        "890bbcfe55da09152be6367010e6a102ea9163b0e95c76a93051f41fc069a84d"
    sha256 cellar: :any,                 ventura:       "87f744512b9c327b249c529495b8604cb6e4b0dbcd4bccbe8380e300dc1dfde8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44e368da9249571e6f5cc634b511d39adf5dc28c8cf667a893740a9201807e5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "deeadf7f6f8e636fecafd58b7b3c201f1303f7b971af0667d43c54ccf3977bc7"
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
