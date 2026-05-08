class Modsecurity < Formula
  desc "Libmodsecurity is one component of the ModSecurity v3 project"
  homepage "https://github.com/owasp-modsecurity/ModSecurity"
  url "https://github.com/owasp-modsecurity/ModSecurity/releases/download/v3.0.15/modsecurity-v3.0.15.tar.gz"
  sha256 "c276c838df6b61d96aa52075aee17d426af52755e16d09edca9f9d718696fda7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d5a9b95a6b7000c5cc0e4a5e664b598e2ed0090e9bf7714a8ab432398d6f430f"
    sha256 cellar: :any,                 arm64_sequoia: "a83b3b90f2d31ff249593a2a0b712c5ab41234741fe2981247dfdfe8e3aa51a3"
    sha256 cellar: :any,                 arm64_sonoma:  "04ef367e843ceb1402b4efe5b5779aac591f79490fcaf3da7ab283abd4c4a669"
    sha256 cellar: :any,                 sonoma:        "b4328c6cec5f19f7f6197b944bdfbc26eecfab6e4bfa083cb2f02102ec575e4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a35e3dad3df682212ae6ef0e617e5fb263c5befdd868275f978cbbc7c096076"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46e066f4000892a21daf9f4451c05e4cee6f173cfb72ed1da2a32dc4cc4da971"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libmaxminddb"
  depends_on "lua@5.4"
  depends_on "pcre2"
  depends_on "yajl"

  uses_from_macos "curl", since: :monterey
  uses_from_macos "libxml2"

  def install
    system "autoreconf", "--force", "--install", "--verbose"

    libxml2 = OS.mac? ? "#{MacOS.sdk_path_if_needed}/usr" : Formula["libxml2"].opt_prefix

    args = [
      "--disable-debug-logs",
      "--disable-doxygen-html",
      "--disable-examples",
      "--disable-silent-rules",
      "--with-libxml=#{libxml2}",
      "--with-lua=#{Formula["lua@5.4"].opt_prefix}",
      "--with-pcre2=#{Formula["pcre2"].opt_prefix}",
      "--with-yajl=#{Formula["yajl"].opt_prefix}",
      "--without-geoip",
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/modsec-rules-check \"SecAuditEngine RelevantOnly\"")
    assert_match("Test ok", output)
  end
end
