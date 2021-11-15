class NagiosPlugins < Formula
  desc "Plugins for the nagios network monitoring system"
  homepage "https://www.nagios-plugins.org/"
  url "https://www.nagios-plugins.org/download/nagios-plugins-2.3.3.tar.gz"
  sha256 "07859071632ded58c5135d613438137022232da75f8bdc1687f3f75da2fe597f"
  license "GPL-3.0"
  head "https://github.com/nagios-plugins/nagios-plugins.git", branch: "master"

  livecheck do
    url "https://nagios-plugins.org/download/"
    regex(/href=.*?nagios-plugins[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "e16175975182c9a77c3a8606c67028c83c7ad3dde9574a5caa949e98b1032e6f"
    sha256 cellar: :any, arm64_big_sur:  "c1668e45b54d3654123117a0a7c365cb8f456fd5c9128e571c1553abbefb5b1f"
    sha256 cellar: :any, monterey:       "46db6fbe86c1ca0917e24d9960c5c7b93d45160093aaa5b014a59342e24d5423"
    sha256 cellar: :any, big_sur:        "af8499231b3f5728465e53f3f3dc8b7dd02172afa118b5c7607a11d69994566d"
    sha256 cellar: :any, catalina:       "b90c6f268ed5a5310a797855d87730f016c5d5077fa7b131c929aee042a1ee6c"
    sha256 cellar: :any, mojave:         "9dc95d628b0ca0e63df426e933f2be374442fa6ea3c6db0ea24ffb5967d098b1"
    sha256 cellar: :any, high_sierra:    "873811a29453153cd0ace61f92be73ae33b4a5bec1a4ece13baf128b32250e6e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "openssl@1.1"

  conflicts_with "monitoring-plugins", because: "both install their plugins to the same folder"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{libexec}
      --libexecdir=#{libexec}/sbin
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
    ]

    system "./tools/setup" if build.head?
    system "./configure", *args
    system "make", "install"
    sbin.write_exec_script Dir["#{libexec}/sbin/*"]
  end

  def caveats
    <<~EOS
      All plugins have been installed in:
        #{HOMEBREW_PREFIX}/sbin
    EOS
  end

  test do
    output = shell_output("#{sbin}/check_dns -H brew.sh -s 8.8.8.8 -t 3")
    assert_match "DNS OK", output
  end
end
